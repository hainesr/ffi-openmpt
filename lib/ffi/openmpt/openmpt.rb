# frozen_string_literal: true

# Copyright (c) 2018, 2019, Robert Haines.
#
# Licensed under the BSD License. See LICENCE for details.

module FFI
  module OpenMPT
    def self.library_version
      maj, min, pat = [API.openmpt_get_library_version].pack('L>').unpack('CCS')
      [maj, min, pat >> 8]
    end

    def self.core_version
      [API.openmpt_get_core_version].pack('L>').unpack('CCCC')
    end

    def self.supported_extensions
      ptr = API.openmpt_get_supported_extensions
      ptr.read_string.split(';').map(&:to_sym)
    ensure
      API.openmpt_free_string(ptr)
    end

    def self.extension_supported?(ext)
      API.openmpt_is_extension_supported(ext.to_s) == 1
    end

    def self.transient_error?(error)
      API.openmpt_error_is_transient(error) == 1
    end

    def self.error_string(error)
      ptr = API.openmpt_error_string(error)
      ptr.read_string
    ensure
      API.openmpt_free_string(ptr)
    end

    def self.probe_file(filename)
      probe_size = API.openmpt_probe_file_header_get_recommended_size
      data = ::File.binread(filename, probe_size)
      data_size = ::File.size(filename)
      probe_result = API.openmpt_probe_file_header(
        API::OPENMPT_PROBE_FILE_HEADER_FLAGS_DEFAULT,
        data,
        data.bytesize,
        data_size,
        API::LogSilent, nil, API::ErrorIgnore, nil, nil, nil
      )

      probe_result == API::OPENMPT_PROBE_FILE_HEADER_RESULT_SUCCESS
    end
  end
end
