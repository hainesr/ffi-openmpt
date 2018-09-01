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
    assert_kind_of Array, exts
    refute_empty exts
    exts.each { |ext| assert_kind_of Symbol, ext }
  end

  def test_extension_supported?
    [:mod, :med, :stm, :xm, :it].each do |ext|
      assert ::FFI::OpenMPT.extension_supported?(ext)
    end

    [:aaa, :bbb, :ccc].each do |ext|
      refute ::FFI::OpenMPT.extension_supported?(ext)
    end
  end

  def test_transient_error
    assert ::FFI::OpenMPT.transient_error?(
      ::FFI::OpenMPT::API::OPENMPT_ERROR_OUT_OF_MEMORY
    )

    refute ::FFI::OpenMPT.transient_error?(
      ::FFI::OpenMPT::API::OPENMPT_ERROR_ARGUMENT_NULL_POINTER
    )
  end

  def test_error_string
    [
      [
        ::FFI::OpenMPT::API::OPENMPT_ERROR_OUT_OF_MEMORY,
        'out of memory'
      ],
      [
        ::FFI::OpenMPT::API::OPENMPT_ERROR_ARGUMENT_NULL_POINTER,
        'unknown error'
      ]
    ].each do |error, message|
      assert_equal ::FFI::OpenMPT.error_string(error), message
    end
  end

  def test_probe_good_file
    assert ::FFI::OpenMPT.probe_file(MOD_LAST_SUN)
  end

  def test_probe_bad_file
    refute ::FFI::OpenMPT.probe_file(RAW_LAST_SUN_INT16)
  end
end
