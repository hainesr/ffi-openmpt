# frozen_string_literal: true

# Copyright (c) 2018 Robert Haines.
#
# Licensed under the BSD License. See LICENCE for details.

require 'test_helper'

class FFI::OpenMPT::StringTest < Minitest::Test

  def test_get
    assert_equal ::FFI::OpenMPT::String.get(:url), 'https://lib.openmpt.org/'
  end

  def test_bad_get
    assert_equal ::FFI::OpenMPT::String.get(:xxxx), ''
  end
end
