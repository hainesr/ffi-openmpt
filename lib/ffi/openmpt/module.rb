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

      def self.probe(filename)
        probe_size = API.openmpt_probe_file_header_get_recommended_size
        data = ::File.binread(filename, probe_size)
        data_size = ::File.size(filename)
        probe_result = API.openmpt_probe_file_header(
          OPENMPT_PROBE_FILE_HEADER_FLAGS_DEFAULT,
          data,
          data.bytesize,
          data_size,
          LogSilent, nil, ErrorIgnore, nil, nil, nil
        )

        probe_result == OPENMPT_PROBE_FILE_HEADER_RESULT_SUCCESS
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
