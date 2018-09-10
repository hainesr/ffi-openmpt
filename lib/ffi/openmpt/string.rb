# frozen_string_literal: true

# Copyright (c) 2018 Robert Haines.
#
# Licensed under the BSD License. See LICENCE for details.

module FFI
  module OpenMPT
    module String
      KEYS = [
        :library_version,
        :library_version_major,
        :library_version_minor,
        :library_version_patch,
        :library_version_prerel,
        :library_version_is_release,
        :library_features,
        :core_version,
        :source_url,
        :source_date,
        :source_revision,
        :source_is_modified,
        :source_has_mixed_revisions,
        :source_is_package,
        :build,
        :build_compiler,
        :credits,
        :contact,
        :license,
        :url,
        :support_forum_url,
        :bugtracker_url
      ].freeze

      def self.get(key)
        ptr = API.openmpt_get_string(key.to_s)
        str = ptr.read_string
        API.openmpt_free_string(ptr)

        str
      end

      def self.method_missing(name, *args)
        respond_to?(name) ? get(name) : super
      end

      def self.respond_to_missing?(name, *all)
        KEYS.include?(name) || super
      end
    end
  end
end
