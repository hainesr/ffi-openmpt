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
end
