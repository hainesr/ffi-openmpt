# frozen_string_literal: true

# Copyright (c) 2018 Robert Haines.
#
# Licensed under the BSD License. See LICENCE for details.

require 'coveralls'
Coveralls.wear!

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'ffi/openmpt'

require 'minitest/autorun'

FIXTURES_DIR = ::File.expand_path('fixtures', __dir__)

# Test mods
MOD_LAST_SUN = ::File.join(FIXTURES_DIR, 'lastsun.mod')
