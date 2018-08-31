# frozen_string_literal: true

# Copyright (c) 2018 Robert Haines.
#
# Licensed under the BSD License. See LICENCE for details.

module FFI
  module OpenMPT
    class Module

      include API

      METADATA_KEYS = [
        :type,
        :type_long,
        :container,
        :container_long,
        :tracker,
        :artist,
        :title,
        :date,
        :message,
        :message_raw,
        :warnings
      ].freeze

      def initialize(filename)
        @closed = false
        @mod = read_mod(filename)

        # Allocate a reusable single int buffer.
        # This for use by the 'get_render_params'-type calls.
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

      def duration
        return if closed?
        openmpt_module_get_duration_seconds(@mod)
      end

      def subsongs
        return if closed?
        openmpt_module_get_num_subsongs(@mod)
      end

      def channels
        return if closed?
        openmpt_module_get_num_channels(@mod)
      end

      def orders
        return if closed?
        openmpt_module_get_num_orders(@mod)
      end

      def patterns
        return if closed?
        openmpt_module_get_num_patterns(@mod)
      end

      def instruments
        return if closed?
        openmpt_module_get_num_instruments(@mod)
      end

      def samples
        return if closed?
        openmpt_module_get_num_samples(@mod)
      end

      def metadata(key)
        return if closed? || !METADATA_KEYS.include?(key)
        get_openmpt_string(:openmpt_module_get_metadata, key.to_s)
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
        METADATA_KEYS.include?(name) || super
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

      def get_openmpt_string(method, *args)
        ptr = send(method, @mod, *args)
        str = ptr.read_string
        openmpt_free_string(ptr)

        str
      end
    end
  end
end
