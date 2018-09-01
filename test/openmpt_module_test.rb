# frozen_string_literal: true

# Copyright (c) 2018 Robert Haines.
#
# Licensed under the BSD License. See LICENCE for details.

require 'test_helper'

class FFI::OpenMPT::ModuleTest < Minitest::Test

  def test_create_and_destroy
    mod = ::FFI::OpenMPT::Module.new(MOD_LAST_SUN)
    refute_equal mod, 0
    assert_equal mod.sample_rate, 48_000
    mod.close
  end

  def test_create_with_sample_rate
    mod = ::FFI::OpenMPT::Module.new(MOD_LAST_SUN, 44_100)
    refute_equal mod, 0
    assert_equal mod.sample_rate, 44_100
    mod.close
  end

  def test_open
    mod = ::FFI::OpenMPT::Module.open(MOD_LAST_SUN)
    refute mod.closed?
    assert_equal mod.sample_rate, 48_000
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
      assert_equal mod.sample_rate, 48_000
    end
  end

  def test_open_block_and_change_sample_rate
    ::FFI::OpenMPT::Module.open(MOD_LAST_SUN) do |mod|
      refute_equal mod, 0
      assert_equal mod.sample_rate, 48_000

      mod.sample_rate = 44_100
      assert_equal mod.sample_rate, 44_100

      mod.sample_rate = 7_999
      assert_equal mod.sample_rate, 44_100

      mod.sample_rate = 192_001
      assert_equal mod.sample_rate, 44_100

      mod.sample_rate = 8_000
      assert_equal mod.sample_rate, 8_000

      mod.sample_rate = 192_000
      assert_equal mod.sample_rate, 192_000
    end
  end

  def test_informational_calls
    m = ::FFI::OpenMPT::Module.open(MOD_LAST_SUN) do |mod|
      assert_in_epsilon mod.duration, 236.4, 0.001
      assert_equal mod.subsongs, 1
      assert_equal mod.channels, 4
      assert_equal mod.orders, 35
      assert_equal mod.patterns, 20
      assert_equal mod.instruments, 0
      assert_equal mod.samples, 15
    end

    assert_nil m.duration
    assert_nil m.subsongs
    assert_nil m.channels
    assert_nil m.orders
    assert_nil m.patterns
    assert_nil m.instruments
    assert_nil m.samples
  end

  def test_metadata
    m = ::FFI::OpenMPT::Module.open(MOD_LAST_SUN) do |mod|
      METADATA_KEYS_LAST_SUN.each do |key, value|
        assert_equal mod.metadata(key), value
      end

      assert_nil mod.metadata(:xxxx)
    end

    assert_nil m.metadata(:title)
  end

  def test_metadata_as_methods
    m = ::FFI::OpenMPT::Module.open(MOD_LAST_SUN) do |mod|
      METADATA_KEYS_LAST_SUN.each do |key, value|
        assert_equal mod.send(key), value
      end

      assert_raises(NoMethodError) do
        mod.xxxx
      end
    end

    assert_nil m.title
  end

  def test_render_params_gain
    ::FFI::OpenMPT::Module.open(MOD_LAST_SUN) do |mod|
      assert_equal mod.gain, 0

      mod.gain = 100
      assert_equal mod.gain, 100
    end
  end

  def test_render_params_stereo
    ::FFI::OpenMPT::Module.open(MOD_LAST_SUN) do |mod|
      assert_equal mod.stereo_separation, 100

      mod.stereo_separation = 200
      assert_equal mod.stereo_separation, 200

      mod.stereo_separation = 201
      assert_equal mod.stereo_separation, 200

      mod.stereo_separation = -1
      assert_equal mod.stereo_separation, 0
    end
  end

  def test_render_params_filter
    ::FFI::OpenMPT::Module.open(MOD_LAST_SUN) do |mod|
      assert_equal mod.interpolation_filter, 8

      mod.interpolation_filter = 4
      assert_equal mod.interpolation_filter, 4

      mod.interpolation_filter = 16
      assert_equal mod.interpolation_filter, 8

      mod.interpolation_filter = -1
      assert_equal mod.interpolation_filter, 8
    end
  end

  def test_render_params_ramping
    ::FFI::OpenMPT::Module.open(MOD_LAST_SUN) do |mod|
      assert_equal mod.volume_ramping, -1

      mod.volume_ramping = 10
      assert_equal mod.volume_ramping, 10
    end
  end
end
