require "rpd/version"
require "rpd/parser"
require "rpd/ipd"
require "rpd/analyser"

module Rpd

	def self.show_dependencies(patch_path)
		da = DepAnalyser.new(Patch.open(patch_path))
		da.walk { |node, level|
			# puts ("  "*level)+node.name
		}
	end

end
