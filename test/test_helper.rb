# frozen_string_literal: true

# Copyright (c) 2018-2020, Robert Haines.
#
# Licensed under the BSD License. See LICENCE for details.

require 'coveralls'
Coveralls.wear!

require 'ffi/openmpt'
require 'fixtures'

require 'minitest/autorun'
require 'tempfile'

# Utility function to ensure that we can capture stderr from the
# external C openmpt library.
def read_stderr
  orig_stderr = STDERR.dup

  Tempfile.open('ffi_openmpt_stderr') do |err|
    STDERR.reopen(err)
    yield
    err.rewind
    err.read
  end
ensure
  STDERR.reopen(orig_stderr)
end

# Data within the test mod
SAMPLE_NAMES_LAST_SUN = [
  'music composed by',
  'fred in march 1989.',
  '',
  'if you need a tune',
  'for a game please',
  'write to',
  '  frederic hahn',
  '  17 rue du haut-barr',
  '  67550 vendenheim',
  '  france.',
  'or call 88-69-40-22',
  '',
  'feel free to rip this',
  'music but please only',
  'use doc 2.0 replayer'
].freeze

METADATA_KEYS_LAST_SUN = [
  [:type, 'mod'],
  [:type_long, 'Generic Amiga / PC MOD file'],
  [:tracker, 'Master Soundtracker 1.0'],
  [:title, 'the last sun'],
  [:message_raw, '']
].freeze
