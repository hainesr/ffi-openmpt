# frozen_string_literal: true

# Copyright (c) 2018 Robert Haines.
#
# Licensed under the BSD License. See LICENCE for details.

require 'test_helper'

class FFI::OpenMPT::APITest < Minitest::Test

  include ::FFI::OpenMPT::API

  def test_get_library_version
    version = openmpt_get_library_version

    refute_nil version
    assert_kind_of Integer, version
  end

  def test_get_core_version
    version = openmpt_get_core_version

    refute_nil version
    assert_kind_of Integer, version
  end

  def test_get_string
    string = openmpt_get_string('url')
    assert_equal string.read_string, 'https://lib.openmpt.org/'
    openmpt_free_string(string)
  end

  def test_get_bad_string
    string = openmpt_get_string('xxxx')
    assert_equal string.read_string, ''
    openmpt_free_string(string)
  end

  def test_get_extensions
    exts = openmpt_get_supported_extensions
    refute_equal exts.read_string, ''
    assert exts.read_string.include?(';')
    openmpt_free_string(exts)
  end

  def test_extension_supported
    %w[mod med stm xm it].each do |ext|
      assert_equal openmpt_is_extension_supported(ext), 1
    end

    %w[aaa bbb ccc].each do |ext|
      assert_equal openmpt_is_extension_supported(ext), 0
    end
  end

  def test_logging_funcs
    assert_nil openmpt_log_func_default('hello', nil)
    assert_nil openmpt_log_func_silent('hello', nil)
  end

  def test_error_funcs
    assert_equal openmpt_error_func_default(1, nil),
                 OPENMPT_ERROR_FUNC_RESULT_DEFAULT
    assert_equal openmpt_error_func_log(1, nil),
                 OPENMPT_ERROR_FUNC_RESULT_LOG
    assert_equal openmpt_error_func_store(1, nil),
                 OPENMPT_ERROR_FUNC_RESULT_STORE
    assert_equal openmpt_error_func_ignore(1, nil),
                 OPENMPT_ERROR_FUNC_RESULT_NONE
  end

  def test_create_module
    data = load_mod_data(MOD_LAST_SUN)

    begin
      mod = openmpt_module_create_from_memory2(data, data.size, LogSilent, nil,
                                               ErrorIgnore, nil, nil, nil, nil)
      refute_nil mod
      refute_equal mod.address, 0
    ensure
      assert_nil openmpt_module_destroy(mod)
    end
  end

  def test_create_module_bad_data
    data = ::FFI::MemoryPointer.new(:char, 0)

    mod = openmpt_module_create_from_memory2(data, data.size, LogSilent, nil,
                                             ErrorIgnore, nil, nil, nil, nil)
    assert_equal mod.address, 0
  end

  def test_module_get_duration
    module_test(MOD_LAST_SUN) do |mod|
      dur = openmpt_module_get_duration_seconds(mod)
      assert_kind_of ::Float, dur
      refute_equal dur, 0
    end
  end

  def test_module_read_stereo
    srate = 48_000
    duration = 10
    frames = srate / duration

    raw = ::File.read(RAW_LAST_SUN_INT16)
    left = ::FFI::MemoryPointer.new(:short, frames)
    right = ::FFI::MemoryPointer.new(:short, frames)

    module_test(MOD_LAST_SUN) do |mod|
      100.times do |i|
        count = openmpt_module_read_stereo(mod, srate, frames, left, right)
        assert_equal frames, count

        rendered = left.read_array_of_int16(count)
                       .zip(right.read_array_of_int16(count)).flatten

        bytesize = frames * 2 * 2
        oracle = raw.byteslice((i * bytesize), bytesize).unpack('s*')
        assert_equal rendered, oracle
      end
    end
  end

  def test_module_read_float_stereo
    srate = 48_000
    duration = 10
    frames = srate / duration

    raw = ::File.read(RAW_LAST_SUN_FLOAT)
    left = ::FFI::MemoryPointer.new(:float, frames)
    right = ::FFI::MemoryPointer.new(:float, frames)

    module_test(MOD_LAST_SUN) do |mod|
      100.times do |i|
        count =
          openmpt_module_read_float_stereo(mod, srate, frames, left, right)
        assert_equal frames, count

        rendered = left.read_array_of_float(count)
                       .zip(right.read_array_of_float(count)).flatten

        bytesize = frames * 2 * 4
        oracle = raw.byteslice((i * bytesize), bytesize).unpack('e*')
        assert_equal rendered, oracle
      end
    end
  end

  def test_module_read_interleaved_stereo
    srate = 48_000
    duration = 10
    frames = srate / duration

    raw = ::File.read(RAW_LAST_SUN_INT16)
    buf = ::FFI::MemoryPointer.new(:short, frames * 2)

    module_test(MOD_LAST_SUN) do |mod|
      100.times do |i|
        count = openmpt_module_read_interleaved_stereo(mod, srate, frames, buf)
        assert_equal frames, count

        bytesize = frames * 2 * 2
        oracle = raw.byteslice((i * bytesize), bytesize).unpack('s*')
        assert_equal buf.read_array_of_int16(count * 2), oracle
      end
    end
  end

  def test_module_read_interleaved_float_stereo
    srate = 48_000
    duration = 10
    frames = srate / duration

    raw = ::File.read(RAW_LAST_SUN_FLOAT)
    buf = ::FFI::MemoryPointer.new(:float, frames * 2)

    module_test(MOD_LAST_SUN) do |mod|
      100.times do |i|
        count =
          openmpt_module_read_interleaved_float_stereo(mod, srate, frames, buf)
        assert_equal frames, count

        bytesize = frames * 2 * 4
        oracle = raw.byteslice((i * bytesize), bytesize).unpack('e*')
        assert_equal buf.read_array_of_float(count * 2), oracle
      end
    end
  end

  private

  def load_mod_data(file)
    data = ::File.read(file)
    buffer = ::FFI::MemoryPointer.new(:char, data.bytesize)
    buffer.put_bytes(0, data)
    buffer
  end

  def module_test(file)
    data = load_mod_data(file)
    mod = openmpt_module_create_from_memory2(data, data.size, LogSilent, nil,
                                             ErrorIgnore, nil, nil, nil, nil)
    yield mod if block_given?
  ensure
    openmpt_module_destroy(mod)
  end
end
