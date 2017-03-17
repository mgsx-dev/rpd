
require "pd-ruby/parser.rb"
require "test/unit"
 
class TestParser < Test::Unit::TestCase
 
  def test_parse_nominal
  	patch = Pd::Patch.open("test/full.pd")
    assert_equal(12, patch.atoms.size)

    atom = patch.atoms[4]

    assert_equal("obj", atom.meta_type)
    assert_equal(196, atom.x)
    assert_equal(175, atom.y)
    assert_equal("varying", atom.type)
    assert_equal(["vec2", "v_texCoords"], atom.parameters)
    assert_equal(4, atom.id)

    # check inlets
    assert_equal(1, atom.inlets.size)
	inlet = atom.inlets.first
	assert_equal(1, inlet.nodes.size)
	assert_same(patch.atoms[0].outlets[0], inlet.nodes.first)

	# check outlets
    assert_equal(1, atom.outlets.size)
	outlet = atom.outlets.first
	assert_equal(1, outlet.nodes.size)
	assert_same(patch.atoms[6].inlets[0], outlet.nodes.first)

  end

  def test_normalize_nominal
  	patch = Pd::Patch.open("test/full.pd")

  	atom = patch.atoms[11]

  	assert_equal("1", atom.type)
  	assert_equal([], atom.parameters)

  	Pd::Patch.normalize(patch)


  	assert_equal("f", atom.type)
  	assert_equal([1.0], atom.parameters)

  end
 
end