# frozen_string_literal: true

# Copyright (c) 2018 Robert Haines.
#
# Licensed under the BSD License. See LICENCE for details.

module FFI
  module OpenMPT
    module String
      def self.get(key)
        ptr = API.openmpt_get_string(key.to_s)
        str = ptr.read_string
        API.openmpt_free_string(ptr)

        str
      end
    end
  end
end
