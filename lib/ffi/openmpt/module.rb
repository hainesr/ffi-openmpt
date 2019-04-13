# frozen_string_literal: true

# Copyright (c) 2018 Robert Haines.
#
# Licensed under the BSD License. See LICENCE for details.

module FFI
  module OpenMPT
    class Module

      include API

      attr_reader :sample_rate

      def initialize(filename, sample_rate = 48_000)
        @closed = false
        @mod = read_mod(filename)
        @sample_rate = sample_rate

        # Allocate a reusable single int buffer.
        # This is for use by the 'get_render_params'-type calls.
        # FFI::MemoryPointer is garbage collected automatically.
        @int_value = ::FFI::MemoryPointer.new(:int, 1)
      end

      def self.open(filename)
        m = new(filename)

        if block_given?
          begin
            yield m
          ensure
            m.close
          end
        end

        m
      end

      def sample_rate=(rate)
        @sample_rate = rate if (8_000..192_000).cover?(rate)
      end

      def duration
        return if closed?
        openmpt_module_get_duration_seconds(@mod)
      end

      def num_subsongs
        return if closed?
        openmpt_module_get_num_subsongs(@mod)
      end

      def num_channels
        return if closed?
        openmpt_module_get_num_channels(@mod)
      end

      def channel_names
        get_names(num_channels, :openmpt_module_get_channel_name)
      end

      def num_orders
        return if closed?
        openmpt_module_get_num_orders(@mod)
      end

      def order_names
        get_names(num_orders, :openmpt_module_get_order_name)
      end

      def num_patterns
        return if closed?
        openmpt_module_get_num_patterns(@mod)
      end

      def pattern_names
        get_names(num_patterns, :openmpt_module_get_pattern_name)
      end

      def num_instruments
        return if closed?
        openmpt_module_get_num_instruments(@mod)
      end

      def instrument_names
        get_names(num_instruments, :openmpt_module_get_instrument_name)
      end

      def num_samples
        return if closed?
        openmpt_module_get_num_samples(@mod)
      end

      def sample_names
        get_names(num_samples, :openmpt_module_get_sample_name)
      end

      def repeat_count
        openmpt_module_get_repeat_count(@mod)
      end

      def repeat_count=(count)
        openmpt_module_set_repeat_count(@mod, count)
      end

      def position
        return if closed?
        openmpt_module_get_position_seconds(@mod)
      end

      def position=(param)
        if param.is_a?(Array)
          openmpt_module_set_position_order_row(@mod, param[0], param[1])
        else
          openmpt_module_set_position_seconds(@mod, param)
        end
      end

      def metadata_keys
        ptr = openmpt_module_get_metadata_keys(@mod)
        ptr.read_string.split(';').map(&:to_sym)
      ensure
        openmpt_free_string(ptr)
      end

      def metadata(key)
        return if closed? || !metadata_keys.include?(key)

        ptr = openmpt_module_get_metadata(@mod, key.to_s)
        ptr.read_string
      ensure
        openmpt_free_string(ptr)
      end

      def gain
        success = openmpt_module_get_render_param(
          @mod, OPENMPT_MODULE_RENDER_MASTERGAIN_MILLIBEL, @int_value
        )

        success == 1 ? @int_value.read_int : nil
      end

      def gain=(value)
        openmpt_module_set_render_param(
          @mod, OPENMPT_MODULE_RENDER_MASTERGAIN_MILLIBEL, value
        )
      end

      def stereo_separation
        success = openmpt_module_get_render_param(
          @mod, OPENMPT_MODULE_RENDER_STEREOSEPARATION_PERCENT, @int_value
        )

        success == 1 ? @int_value.read_int : nil
      end

      def stereo_separation=(value)
        openmpt_module_set_render_param(
          @mod, OPENMPT_MODULE_RENDER_STEREOSEPARATION_PERCENT, value
        )
      end

      def interpolation_filter
        success = openmpt_module_get_render_param(
          @mod, OPENMPT_MODULE_RENDER_INTERPOLATIONFILTER_LENGTH, @int_value
        )

        success == 1 ? @int_value.read_int : nil
      end

      def interpolation_filter=(value)
        openmpt_module_set_render_param(
          @mod, OPENMPT_MODULE_RENDER_INTERPOLATIONFILTER_LENGTH, value
        )
      end

      def volume_ramping
        success = openmpt_module_get_render_param(
          @mod, OPENMPT_MODULE_RENDER_VOLUMERAMPING_STRENGTH, @int_value
        )

        success == 1 ? @int_value.read_int : nil
      end

      def volume_ramping=(value)
        openmpt_module_set_render_param(
          @mod, OPENMPT_MODULE_RENDER_VOLUMERAMPING_STRENGTH, value
        )
      end

      def read_mono(frames, buffer)
        openmpt_module_read_mono(@mod, @sample_rate, frames, buffer)
      end

      def read_float_mono(frames, buffer)
        openmpt_module_read_float_mono(@mod, @sample_rate, frames, buffer)
      end

      def read_stereo(frames, left, right)
        openmpt_module_read_stereo(@mod, @sample_rate, frames, left, right)
      end

      def read_interleaved_stereo(frames, buffer)
        openmpt_module_read_interleaved_stereo(
          @mod, @sample_rate, frames, buffer
        )
      end

      def read_float_stereo(frames, left, right)
        openmpt_module_read_float_stereo(
          @mod, @sample_rate, frames, left, right
        )
      end

      def read_interleaved_float_stereo(frames, buffer)
        openmpt_module_read_interleaved_float_stereo(
          @mod, @sample_rate, frames, buffer
        )
      end

      def close
        return if closed?
        @closed = true
        openmpt_module_destroy(@mod)
      end

      def closed?
        @closed
      end

      def method_missing(name, *args)
        respond_to?(name) ? metadata(name) : super
      end

      def respond_to_missing?(name, *all)
        metadata_keys.include?(name) || super
      end

      private

      def read_mod(filename)
        data = ::File.binread(filename)
        mod = openmpt_module_create_from_memory2(
          data,
          data.bytesize,
          LogSilent, nil, ErrorIgnore, nil, nil, nil, nil
        )

        @closed = (mod.address == 0)
        mod
      end

      def get_names(num, get)
        (0...num).reduce([]) do |acc, i|
          ptr = send(get, @mod, i)
          acc << ptr.read_string
        ensure
          openmpt_free_string(ptr)
        end
      end
    end
  end
end
