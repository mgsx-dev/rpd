require "rpd/parser"

module Rpd

	class DepAnalyser
		def initialize(patch)
			@patch = patch
			@map = {}
		end

		def walk(&block)
			walk_patch(@patch, 0, &block)
		end

		private

		def walk_patch(patch, level, &block)
			yield patch, level
			if not @map[patch.name] then
				patch.atoms.each do |atom|
					if not Patch.vanilla?(atom.name) then
						abs = @map[atom.name]
						abs_path = "#{File.dirname(patch.file)}/#{atom.name}.pd"
						begin
							abs = Patch.open(abs_path)
						rescue
							abs = UnresolvedPatch.new(abs_path)
							abs.data = OpenStruct.new({atoms: []})
						end unless abs
						walk_patch(abs, level+1, &block)
					end
				end

			end
			
			# scan atoms
		end

	end

	private

	class UnresolvedPatch < Patch 
		def initilize(file)
			super(file)
		end
		def name
			super + ' (missing)'
		end
	end

end