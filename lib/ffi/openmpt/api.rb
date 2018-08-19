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

      # Error handling API calls
      OPENMPT_ERROR_FUNC_RESULT_NONE    = 0
      OPENMPT_ERROR_FUNC_RESULT_LOG     = (1 << 0)
      OPENMPT_ERROR_FUNC_RESULT_STORE   = (1 << 1)
      OPENMPT_ERROR_FUNC_RESULT_DEFAULT =
        (OPENMPT_ERROR_FUNC_RESULT_LOG | OPENMPT_ERROR_FUNC_RESULT_STORE)

      ErrorDefault =
        attach_function :openmpt_error_func_default, [:int, :pointer], :int
      ErrorLog =
        attach_function :openmpt_error_func_log, [:int, :pointer], :int
      ErrorStore =
        attach_function :openmpt_error_func_store, [:int, :pointer], :int
      ErrorIgnore =
        attach_function :openmpt_error_func_ignore, [:int, :pointer], :int

      # Module API calls
      attach_function :openmpt_module_create_from_memory2,
                      [
                        :pointer, :int, :pointer, :pointer, :pointer,
                        :pointer, :pointer, :pointer, :pointer
                      ],
                      :pointer
      attach_function :openmpt_module_destroy, [:pointer], :void
      attach_function :openmpt_module_get_duration_seconds, [:pointer], :double
    end
  end
end
