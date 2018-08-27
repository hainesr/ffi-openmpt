# frozen_string_literal: true

# Copyright (c) 2018 Robert Haines.
#
# Licensed under the BSD License. See LICENCE for details.

require 'test_helper'

class FFI::OpenMPT::ModuleTest < Minitest::Test

  def test_probe_good_file
    assert ::FFI::OpenMPT::Module.probe(MOD_LAST_SUN)
  end

  def test_probe_bad_file
    refute ::FFI::OpenMPT::Module.probe(RAW_LAST_SUN_INT16)
  end

  def test_create_and_destroy
    mod = ::FFI::OpenMPT::Module.new(MOD_LAST_SUN)
    refute_equal mod, 0
    mod.close
  end

  def test_open
    mod = ::FFI::OpenMPT::Module.open(MOD_LAST_SUN)
    refute mod.closed?
    mod.close
    assert mod.closed?
  end

  def test_open_bad
    mod = ::FFI::OpenMPT::Module.open(RAW_LAST_SUN_INT16)
    assert mod.closed?
    mod.close
    assert mod.closed?
  end

  def test_open_block
    ::FFI::OpenMPT::Module.open(MOD_LAST_SUN) do |mod|
      refute_equal mod, 0
    end
  end

  def test_informational_calls
    ::FFI::OpenMPT::Module.open(MOD_LAST_SUN) do |mod|
      assert_in_epsilon mod.duration, 236.4, 0.001
      assert_equal mod.subsongs, 1
      assert_equal mod.channels, 4
      assert_equal mod.orders, 35
      assert_equal mod.patterns, 20
      assert_equal mod.instruments, 0
      assert_equal mod.samples, 15
    end
  end

  def test_metadata
    ::FFI::OpenMPT::Module.open(MOD_LAST_SUN) do |mod|
      METADATA_KEYS_LAST_SUN.each do |key, value|
        assert_equal mod.metadata(key), value
      end

      assert_nil mod.metadata(:xxxx)
    end
  end
end
