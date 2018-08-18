# frozen_string_literal: true

# Copyright (c) 2018 Robert Haines.
#
# Licensed under the BSD License. See LICENCE for details.

require 'coveralls'
Coveralls.wear!

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "ffi/openmpt"

require "minitest/autorun"
