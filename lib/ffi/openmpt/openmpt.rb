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
  end
end
