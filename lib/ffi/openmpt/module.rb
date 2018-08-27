# frozen_string_literal: true

# Copyright (c) 2018 Robert Haines.
#
# Licensed under the BSD License. See LICENCE for details.

module FFI
  module OpenMPT
    class Module

      include API

      def initialize(filename)
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

      def close
        openmpt_module_destroy(@mod)
      end

      private

      def read_mod(filename)
        data = ::File.binread(filename)
        openmpt_module_create_from_memory2(
          data,
          data.bytesize,
          LogSilent, nil, ErrorIgnore, nil, nil, nil, nil
        )
      end
    end
  end
end
