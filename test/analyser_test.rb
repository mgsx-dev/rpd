require 'test_helper'

class AnalyserTest < Minitest::Test
  def test_walk
  	a = DepAnalyser.new(Patch.open("test/full.pd"))
  	a.walk { |node, level|
  		# puts (" "*level)+node.name
	}
  end
  def test_walk_graph_1
  	a = DepAnalyser.new(Patch.open("test/data/graph1/main.pd"))
  	r = []
  	a.walk { |node, level|
  		r << [level, node.name]
	}
	assert_equal([[0, 'main'], [1, 'missing (missing)'], [1, 'root-abs'], [1, 'sub-abs']], r)
  end
  def test_walk_graph_2
  	a = DepAnalyser.new(Patch.open("test/data/graph2/main.pd"))
  	r = []
  	a.walk { |node, level|
  		r << [level, node.name]
	}
	assert_equal([[0, 'main'], [1, 'abs-a'], [2, 'abs-b']], r)
  end
  def test_walk_graph_3
  	a = DepAnalyser.new(Patch.open("test/data/graph3/main.pd"))
  	r = []
  	a.walk { |node, level|
  		r << [level, node.name]
	}
	assert_equal([[0, 'main'], [1, 'abs-a'], [1, 'abs-b']], r)
  end
  def test_walk_vanilla
  	a = DepAnalyser.new(Patch.open("data/vanilla-0.47.1.pd"))
  	r = []
  	a.walk { |node, level|
  		r << [level, node.name]
	}
	assert_equal([[0, 'vanilla-0.47.1']], r)
  end

end
