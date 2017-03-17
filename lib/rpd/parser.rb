
class String
  def is_number?
    true if Float(self) rescue false
  end
end

module Pd

	require 'ostruct'

	class Patch

		def self.open(file)
			parse(File.read(file))
		end

		def self.parse(content)
			patch = Patch.new
			atoms = []
			id = 0
			content.split("\n").each do |line|
				args = line[0..(line.length-2)].split(" ")
				case args.shift
				when "#N" then
				when "#X" then
					case meta_type = args.shift
					when "obj" then
						atom = OpenStruct.new
						atom.meta_type = meta_type
						atom.x = args.shift.to_i
						atom.y = args.shift.to_i
						atom.type = args.shift.to_s
						atom.parameters = args
						atom.id = id
						atom.inlets = []
						atom.outlets = []
						#atom.model = $abstractions[atom.type.to_sym]
						#atom.model = $builtin[atom.type.to_sym] unless atom.model
						#if (not atom.model) and atom.type.is_number? then
						#	atom.model = $builtin[:f]
						#	atom.parameters = [atom.type.to_f]
						#	atom.type = "f"
						#end
						#atom.model = $builtin[:f] unless atom.model and not atom.type.is_number?	
						#puts atom				
						atoms << atom
					when "connect" then
						srcId, outlet, dstId, inlet = args.map(&:to_i)
						srcAtom = atoms[srcId]
						dstAtom = atoms[dstId]
						raise "not found atom id #{srcId}" unless srcAtom
						raise "not found atom id #{dstId}" unless dstAtom
						srcAtom.outlets[outlet] = OpenStruct.new({nodes: [], atom: srcAtom}) unless srcAtom.outlets[outlet]
						dstAtom.inlets[inlet] = OpenStruct.new({nodes: [], atom: dstAtom}) unless dstAtom.inlets[inlet]
						srcAtom.outlets[outlet].nodes << dstAtom.inlets[inlet]
						dstAtom.inlets[inlet].nodes << srcAtom.outlets[outlet]
					else 			
						atoms << nil
					end
					id += 1
				else end
			end

			OpenStruct.new({atoms: atoms.compact})
			# dereference mixed types
			#patch.atoms.each do |atom|
			#	atom and atom.checkType
			#end
		end

		def self.normalize(patch)

			patch.atoms.each do |atom|
				# convert direct number to float atom
				if atom.type.is_number? then
					atom.parameters = [atom.type.to_f]
					atom.type = "f"
				end
			end

		end

	end

end