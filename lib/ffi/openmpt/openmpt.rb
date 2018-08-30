# frozen_string_literal: true

# Copyright (c) 2018 Robert Haines.
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

    def self.string(key)
      ptr = API.openmpt_get_string(key.to_s)
      str = ptr.read_string
      API.openmpt_free_string(ptr)

      str
    end

    def self.supported_extensions
      ptr = API.openmpt_get_supported_extensions
      str = ptr.read_string
      API.openmpt_free_string(ptr)

      str
    end

    def self.extension_supported?(ext)
      supported = API.openmpt_is_extension_supported(ext.to_s)
      supported == 1
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
