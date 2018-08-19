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
