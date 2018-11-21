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
    stderr = read_stderr do
      assert_nil openmpt_log_func_default('hello', nil)
    end
    assert_equal stderr, "openmpt: hello\n"

    stderr = read_stderr do
      assert_nil openmpt_log_func_silent('hello', nil)
    end
    assert_equal stderr, ''
  end

  def test_error_information_funcs
    assert_equal openmpt_error_is_transient(OPENMPT_ERROR_OUT_OF_MEMORY), 1
    assert_equal openmpt_error_is_transient(OPENMPT_ERROR_LOGIC), 0

    err = openmpt_error_string(OPENMPT_ERROR_OUT_OF_MEMORY)
    assert_equal err.read_string, 'out of memory'
    openmpt_free_string(err)

    err = openmpt_error_string(11_111)
    assert_equal err.read_string, 'unknown error'
    openmpt_free_string(err)
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

  def test_module_metadata
    module_test(MOD_LAST_SUN) do |mod|
      keys = openmpt_module_get_metadata_keys(mod)
      refute_equal keys.read_string, ''
      assert keys.read_string.include?(';')
      openmpt_free_string(keys)

      data = openmpt_module_get_metadata(mod, 'type')
      assert_equal data.read_string, 'mod'
      openmpt_free_string(data)

      data = openmpt_module_get_metadata(mod, 'xxxx')
      assert_equal data.read_string, ''
      openmpt_free_string(data)
    end
  end

  def test_other_informational_module_funcs
    module_test(MOD_LAST_SUN) do |mod|
      songs = openmpt_module_get_num_subsongs(mod)
      assert_kind_of Integer, songs
      assert_equal songs, 1

      songs.times do |i|
        name = openmpt_module_get_subsong_name(mod, i)
        refute_nil name
        assert_equal name.read_string, ''
        openmpt_free_string(name)
      end

      channels = openmpt_module_get_num_channels(mod)
      assert_kind_of Integer, channels
      assert_equal channels, 4

      channels.times do |i|
        name = openmpt_module_get_channel_name(mod, i)
        refute_nil name
        assert_equal name.read_string, ''
        openmpt_free_string(name)
      end

      orders = openmpt_module_get_num_orders(mod)
      assert_kind_of Integer, orders
      assert_equal orders, 35

      orders.times do |i|
        name = openmpt_module_get_order_name(mod, i)
        refute_nil name
        assert_equal name.read_string, ''
        openmpt_free_string(name)
      end

      patterns = openmpt_module_get_num_patterns(mod)
      assert_kind_of Integer, patterns
      assert_equal patterns, 20

      patterns.times do |i|
        name = openmpt_module_get_pattern_name(mod, i)
        refute_nil name
        assert_equal name.read_string, ''
        openmpt_free_string(name)
      end

      instruments = openmpt_module_get_num_instruments(mod)
      assert_kind_of Integer, instruments
      assert_equal instruments, 0

      instruments.times do |i|
        name = openmpt_module_get_instrument_name(mod, i)
        refute_nil name
        assert_equal name.read_string, ''
        openmpt_free_string(name)
      end

      samples = openmpt_module_get_num_samples(mod)
      assert_kind_of Integer, samples
      assert_equal samples, 15

      samples.times do |i|
        name = openmpt_module_get_sample_name(mod, i)
        refute_nil name
        assert_equal name.read_string, SAMPLE_NAMES_LAST_SUN[i]
        openmpt_free_string(name)
      end
    end
  end

  def test_get_set_module_errors
    module_test(MOD_LAST_SUN) do |mod|
      errno = openmpt_module_error_get_last(mod)
      err = openmpt_module_error_get_last_message(mod)
      assert_equal errno, OPENMPT_ERROR_OK
      assert_equal err.read_string, ''
      openmpt_free_string(err)

      openmpt_module_error_set_last(mod, OPENMPT_ERROR_UNKNOWN)
      errno = openmpt_module_error_get_last(mod)
      assert_equal errno, OPENMPT_ERROR_UNKNOWN

      openmpt_module_error_clear(mod)
      errno = openmpt_module_error_get_last(mod)
      assert_equal errno, OPENMPT_ERROR_OK
    end
  end

  def test_probe_file_header
    size = openmpt_probe_file_header_get_recommended_size
    assert size > 0

    data = load_mod_data(MOD_LAST_SUN)
    probe_data = data.read_bytes(size)

    load = openmpt_probe_file_header(
      OPENMPT_PROBE_FILE_HEADER_FLAGS_DEFAULT,
      probe_data, size, data.size, LogSilent, nil, ErrorIgnore, nil, nil, nil
    )
    assert_equal load, OPENMPT_PROBE_FILE_HEADER_RESULT_SUCCESS
  end

  def test_module_get_and_set_render_params
    module_test(MOD_LAST_SUN) do |mod|
      value = ::FFI::MemoryPointer.new(:int, 1)
      [
        [OPENMPT_MODULE_RENDER_MASTERGAIN_MILLIBEL, 0, 100],
        [OPENMPT_MODULE_RENDER_STEREOSEPARATION_PERCENT, 100, 200],
        [OPENMPT_MODULE_RENDER_INTERPOLATIONFILTER_LENGTH, 8, 2],
        [OPENMPT_MODULE_RENDER_VOLUMERAMPING_STRENGTH, -1, 10]
      ].each do |param, default, changed|
        result = openmpt_module_get_render_param(mod, param, nil)
        assert_equal result, 0

        result = openmpt_module_get_render_param(mod, param, value)
        assert_equal result, 1
        assert_equal value.read_int, default

        result = openmpt_module_set_render_param(mod, param, changed)
        assert_equal result, 1
        result = openmpt_module_get_render_param(mod, param, value)
        assert_equal result, 1
        assert_equal value.read_int, changed
      end
    end
  end

  def test_module_read_mono
    srate = 48_000
    duration = 10
    frames = srate / duration

    raw = ::File.read(RAW_LAST_SUN_MONO_INT16)
    buf = ::FFI::MemoryPointer.new(:short, frames)

    module_test(MOD_LAST_SUN) do |mod|
      100.times do |i|
        count = openmpt_module_read_mono(mod, srate, frames, buf)
        assert_equal frames, count

        bytesize = frames * 2
        oracle = raw.byteslice((i * bytesize), bytesize).unpack('s*')
        assert_equal buf.read_array_of_int16(count), oracle
      end
    end
  end

  def test_module_read_float_mono
    srate = 48_000
    duration = 10
    frames = srate / duration

    raw = ::File.read(RAW_LAST_SUN_MONO_FLOAT)
    buf = ::FFI::MemoryPointer.new(:float, frames)

    module_test(MOD_LAST_SUN) do |mod|
      100.times do |i|
        count =
          openmpt_module_read_float_mono(mod, srate, frames, buf)
        assert_equal frames, count

        bytesize = frames * 4
        oracle = raw.byteslice((i * bytesize), bytesize).unpack('e*')
        assert_equal buf.read_array_of_float(count), oracle
      end
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
