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
  end
end
