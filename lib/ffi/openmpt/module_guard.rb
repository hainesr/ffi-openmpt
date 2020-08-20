# frozen_string_literal: true

# Copyright (c) 2018-2020, Robert Haines.
#
# Licensed under the BSD License. See LICENCE for details.

module FFI
  module OpenMPT
    module ModuleGuard

      # This method overrides all methods passed to it so that we can check
      # that the underlying mod has not been closed and cleaned up. Calling
      # certain methods on a closed mod will dump the core.
      def guard(*method_names)
        proxy = ::Module.new do
          method_names.each do |m|
            define_method(m) do |*args|
              return if closed?

              super(*args)
            end
          end
        end

        prepend proxy
      end
    end
  end
end
