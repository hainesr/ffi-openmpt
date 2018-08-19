# frozen_string_literal: true

# Copyright (c) 2018 Robert Haines.
#
# Licensed under the BSD License. See LICENCE for details.

module FFI
  module OpenMPT
    module API
      extend FFI::Library

      ffi_lib 'libopenmpt.so.0'

      # Version API calls
      attach_function :openmpt_get_library_version, [], :uint
      attach_function :openmpt_get_core_version, [], :uint

      # Logging API calls
      LogDefault =
        attach_function :openmpt_log_func_default, [:string, :pointer], :void
      LogSilent =
        attach_function :openmpt_log_func_silent, [:string, :pointer], :void
    end
  end
end
