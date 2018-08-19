# frozen_string_literal: true

# Copyright (c) 2018 Robert Haines.
#
# Licensed under the BSD License. See LICENCE for details.

require 'test_helper'

class FFI::OpenMPTTest < Minitest::Test

  def test_that_it_has_a_version_number
    version = ::FFI::OpenMPT::VERSION
    refute_nil version
    assert_kind_of String, version
  end

  def test_the_library_version_number
    version = ::FFI::OpenMPT.library_version
    refute_nil version
    assert_kind_of Array, version
    assert_equal 3, version.length
  end

  def test_the_core_version_number
    version = ::FFI::OpenMPT.core_version
    refute_nil version
    assert_kind_of Array, version
    assert_equal 4, version.length
  end
end
