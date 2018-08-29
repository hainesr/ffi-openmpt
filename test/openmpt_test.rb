# frozen_string_literal: true

# Copyright (c) 2018 Robert Haines.
#
# Licensed under the BSD License. See LICENCE for details.

require 'test_helper'

class FFI::OpenMPTTest < Minitest::Test

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

  def test_string
    assert_equal ::FFI::OpenMPT.string(:url), 'https://lib.openmpt.org/'
  end

  def test_bad_string
    assert_equal ::FFI::OpenMPT.string(:xxxx), ''
  end

  def test_supported_extensions
    exts = ::FFI::OpenMPT.supported_extensions
    refute_equal exts, ''
    assert exts.include?(';')
  end

  def test_extension_supported?
    [:mod, :med, :stm, :xm, :it].each do |ext|
      assert ::FFI::OpenMPT.extension_supported?(ext)
    end

    [:aaa, :bbb, :ccc].each do |ext|
      refute ::FFI::OpenMPT.extension_supported?(ext)
    end
  end
end
