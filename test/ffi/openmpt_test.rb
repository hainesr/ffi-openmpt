# frozen_string_literal: true

# Copyright (c) 2018 Robert Haines.
#
# Licensed under the BSD License. See LICENCE for details.

require 'test_helper'

class FFI::OpenMPTTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::FFI::OpenMPT::VERSION
  end
end
