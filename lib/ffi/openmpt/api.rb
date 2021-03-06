# frozen_string_literal: true

# Copyright (c) 2018, 2019, Robert Haines.
#
# Licensed under the BSD License. See LICENCE for details.

module FFI
  module OpenMPT
    module API
      extend FFI::Library

      ffi_lib 'libopenmpt.so.0'

      # Top-level (library) informational API calls
      attach_function :openmpt_get_library_version, [], :uint
      attach_function :openmpt_get_core_version, [], :uint
      attach_function :openmpt_free_string, [:pointer], :void
      attach_function :openmpt_get_string, [:string], :pointer
      attach_function :openmpt_get_supported_extensions, [], :pointer
      attach_function :openmpt_is_extension_supported, [:string], :int

      # Logging API calls
      LogDefault =
        attach_function :openmpt_log_func_default, [:string, :pointer], :void
      LogSilent =
        attach_function :openmpt_log_func_silent, [:string, :pointer], :void

      # Error handling API calls
      OPENMPT_ERROR_OK                     = 0
      OPENMPT_ERROR_BASE                   = 256

      OPENMPT_ERROR_UNKNOWN                = OPENMPT_ERROR_BASE + 1
      OPENMPT_ERROR_EXCEPTION              = OPENMPT_ERROR_BASE + 11
      OPENMPT_ERROR_OUT_OF_MEMORY          = OPENMPT_ERROR_BASE + 21

      OPENMPT_ERROR_RUNTIME                = OPENMPT_ERROR_BASE + 30
      OPENMPT_ERROR_RANGE                  = OPENMPT_ERROR_BASE + 31
      OPENMPT_ERROR_OVERFLOW               = OPENMPT_ERROR_BASE + 32
      OPENMPT_ERROR_UNDERFLOW              = OPENMPT_ERROR_BASE + 33

      OPENMPT_ERROR_LOGIC                  = OPENMPT_ERROR_BASE + 40
      OPENMPT_ERROR_DOMAIN                 = OPENMPT_ERROR_BASE + 41
      OPENMPT_ERROR_LENGTH                 = OPENMPT_ERROR_BASE + 42
      OPENMPT_ERROR_OUT_OF_RANGE           = OPENMPT_ERROR_BASE + 43
      OPENMPT_ERROR_INVALID_ARGUMENT       = OPENMPT_ERROR_BASE + 44

      OPENMPT_ERROR_GENERAL                = OPENMPT_ERROR_BASE + 101
      OPENMPT_ERROR_INVALID_MODULE_POINTER = OPENMPT_ERROR_BASE + 102
      OPENMPT_ERROR_ARGUMENT_NULL_POINTER  = OPENMPT_ERROR_BASE + 103

      attach_function :openmpt_error_is_transient, [:int], :int
      attach_function :openmpt_error_string, [:int], :pointer

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
      # Creational module calls
      attach_function :openmpt_module_create_from_memory2,
                      [
                        :pointer, :int, :pointer, :pointer, :pointer,
                        :pointer, :pointer, :pointer, :pointer
                      ],
                      :pointer
      attach_function :openmpt_module_destroy, [:pointer], :void

      # Informational module calls
      attach_function :openmpt_module_get_duration_seconds, [:pointer], :double
      attach_function :openmpt_module_get_metadata_keys, [:pointer], :pointer
      attach_function :openmpt_module_get_metadata,
                      [:pointer, :string], :pointer
      attach_function :openmpt_module_get_num_subsongs, [:pointer], :int
      attach_function :openmpt_module_get_subsong_name,
                      [:pointer, :int], :pointer
      attach_function :openmpt_module_get_num_channels, [:pointer], :int
      attach_function :openmpt_module_get_channel_name,
                      [:pointer, :int], :pointer
      attach_function :openmpt_module_get_num_orders, [:pointer], :int
      attach_function :openmpt_module_get_order_name,
                      [:pointer, :int], :pointer
      attach_function :openmpt_module_get_num_patterns, [:pointer], :int
      attach_function :openmpt_module_get_pattern_name,
                      [:pointer, :int], :pointer
      attach_function :openmpt_module_get_num_instruments, [:pointer], :int
      attach_function :openmpt_module_get_instrument_name,
                      [:pointer, :int], :pointer
      attach_function :openmpt_module_get_num_samples, [:pointer], :int
      attach_function :openmpt_module_get_sample_name,
                      [:pointer, :int], :pointer

      # Error module calls
      attach_function :openmpt_module_error_get_last, [:pointer], :int
      attach_function :openmpt_module_error_set_last, [:pointer, :int], :void
      attach_function :openmpt_module_error_get_last_message,
                      [:pointer], :pointer
      attach_function :openmpt_module_error_clear, [:pointer], :void

      # Probe module calls
      OPENMPT_PROBE_FILE_HEADER_FLAGS_NONE          = 0x0
      OPENMPT_PROBE_FILE_HEADER_FLAGS_MODULES       = 0x1
      OPENMPT_PROBE_FILE_HEADER_FLAGS_CONTAINERS    = 0x2
      OPENMPT_PROBE_FILE_HEADER_FLAGS_DEFAULT       =
        (OPENMPT_PROBE_FILE_HEADER_FLAGS_MODULES |
          OPENMPT_PROBE_FILE_HEADER_FLAGS_CONTAINERS)

      OPENMPT_PROBE_FILE_HEADER_RESULT_FAILURE      = 0
      OPENMPT_PROBE_FILE_HEADER_RESULT_SUCCESS      = 1
      OPENMPT_PROBE_FILE_HEADER_RESULT_WANTMOREDATA = -1
      OPENMPT_PROBE_FILE_HEADER_RESULT_ERROR        = -255

      attach_function :openmpt_probe_file_header_get_recommended_size, [], :int
      attach_function :openmpt_probe_file_header,
                      [
                        :uint, :pointer, :int, :uint, :pointer, :pointer,
                        :pointer, :pointer, :pointer, :pointer
                      ],
                      :int

      # Render param module calls
      OPENMPT_MODULE_RENDER_MASTERGAIN_MILLIBEL        = 1
      OPENMPT_MODULE_RENDER_STEREOSEPARATION_PERCENT   = 2
      OPENMPT_MODULE_RENDER_INTERPOLATIONFILTER_LENGTH = 3
      OPENMPT_MODULE_RENDER_VOLUMERAMPING_STRENGTH     = 4

      attach_function :openmpt_module_get_render_param,
                      [:pointer, :int, :pointer], :int
      attach_function :openmpt_module_set_render_param,
                      [:pointer, :int, :int], :int

      # Repeat module calls
      attach_function :openmpt_module_get_repeat_count, [:pointer], :int
      attach_function :openmpt_module_set_repeat_count, [:pointer, :int], :void

      # Positional module calls
      attach_function :openmpt_module_get_position_seconds, [:pointer], :double
      attach_function :openmpt_module_set_position_seconds,
                      [:pointer, :double], :double
      attach_function :openmpt_module_set_position_order_row,
                      [:pointer, :int, :int], :double

      # Real-time playing information calls
      attach_function :openmpt_module_get_current_speed, [:pointer], :int
      attach_function :openmpt_module_get_current_tempo, [:pointer], :int
      attach_function :openmpt_module_get_current_order, [:pointer], :int
      attach_function :openmpt_module_get_current_pattern, [:pointer], :int
      attach_function :openmpt_module_get_current_row, [:pointer], :int
      attach_function :openmpt_module_get_current_playing_channels,
                      [:pointer], :int

      # VU meter calls
      attach_function :openmpt_module_get_current_channel_vu_mono,
                      [:pointer, :int], :float
      attach_function :openmpt_module_get_current_channel_vu_left,
                      [:pointer, :int], :float
      attach_function :openmpt_module_get_current_channel_vu_right,
                      [:pointer, :int], :float

      # Read module calls
      attach_function :openmpt_module_read_mono,
                      [:pointer, :int, :int, :pointer],
                      :int
      attach_function :openmpt_module_read_float_mono,
                      [:pointer, :int, :int, :pointer],
                      :int
      attach_function :openmpt_module_read_stereo,
                      [:pointer, :int, :int, :pointer, :pointer],
                      :int
      attach_function :openmpt_module_read_interleaved_stereo,
                      [:pointer, :int, :int, :pointer],
                      :int
      attach_function :openmpt_module_read_float_stereo,
                      [:pointer, :int, :int, :pointer, :pointer],
                      :int
      attach_function :openmpt_module_read_interleaved_float_stereo,
                      [:pointer, :int, :int, :pointer],
                      :int
    end
  end
end
