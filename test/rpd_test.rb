require 'test_helper'

class RpdTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Rpd::VERSION
  end

  def test_show_dependencies
  	Rpd.show_dependencies("test/full.pd")
  end

end
