require 'socket'

module Rpd


class Pd
	def self.server(&block)

		hostname = 'localhost'
		port = 2000

		ts = TCPSocket.new(hostname, port)
		
		yield ts
		
		ts.close
	end

	def self.obj(x, y, *args)
		server do |s|
			s.puts "obj #{x} #{y} #{args.join(' ')}"
		end
	end

	def self.spawn
		@@pid = Process.spawn('pd -send "pd-remote.pd vis 0" data/remote.pd')
		["EXIT", "TERM", "ABRT"].each do |sig| Signal.trap(sig) { Pd.exit } end
	end

	def self.exit
		puts "try killing pd : #{@@pid}"
		Process.detach(@@pid)
		Process.kill(9, @@pid)
		Process.waitall
	end


	def self.path
		File.dirname(__FILE__)
	end


	# send raw message(s) to Pd
	# message can be a string or an array of string.
	# commas are automatically added.
	def self.<<(message)
		server do |s|
			if message.kind_of?(Array) then
				s.puts message.join(";") + ";"
			else
				s.puts message + ";"
			end
		end
	end

	def self.create(filename, x=65, y=81, w=450, h=300, font=10)
		File.write(filename, "#N canvas #{x} #{y} #{w} #{h} #{font};")
		open(filename)
	end

	def self.open(filename)
		# TODO format is : pd open [relative path] [from absolute path], eg. "pd open foo.pd /foo/bar" can be "pd open bar/foo.pd /foo"
		self << "pd open #{File.basename(filename)} #{File.dirname(File.absolute_path(filename))}"
	end

	def self.obj(patch, name, x=10, y=10, *args)
		self << "pd-#{patch} obj #{x} #{y} #{name} #{args.join(' ')}"
	end

	def self.connect(patch, src_id, src_port, dst_id, dst_port)
		self << "pd-#{patch} connect #{src_id} #{src_port} #{dst_id} #{dst_port}"
	end

	def self.clear(patch)
		self << "pd-#{patch} clear"
	end

	def self.close(patch)
		self << "pd-#{patch} menuclose"
	end

	def self.show(patch)
		self << "pd-#{patch} vis 1"
	end

	def self.hide(patch)
		self << "pd-#{patch} vis 0"
	end

	def self.edit(patch, mode)
		self << "pd-#{patch} editmode #{mode ? 1 : 0}"
	end

	def self.msg(patch, x=10, y=10, *args)
		self << "pd-#{patch} msg #{x} #{y} #{args.join(' ')}"
	end

	def self.select_all(patch)
		self << "pd-#{patch} selectall"
	end

	def self.dsp(mode)
		self << "pd dsp #{mode ? 1 : 0}"
	end

	def self.canvas(patch, x, y, w, h, send, recv, content)
		content = content ? content.gsub(/ /, "\\ ").gsub(/\n/, "\\\n") : 'empty'
		self << "pd-#{patch} obj #{x} #{y} cnv 15 #{w} #{h} #{send} #{recv} #{content} 20 120 0 14 -233017 -66577 0"
	end

	# obj, msg and any of :
	# floatatom, symbolatom, text

	# case of canvas :
	# obj $1 $2 cnv 15 100 60 id-rcv id-snd empty 20 12 0 14 -233017 -66577 0
	# obj x y cnv ??? w h id-rcv id-snd empty 20 12 0 14 -233017 -66577 0


	# Mouse and keyboard interaction !

	# find & find again


end



class PdTuto

	def self.start

		if false then
		puts "3..."
		sleep 1
		puts "2..."
		sleep 1
		puts "1..."
		sleep 1
	end

		sw = 1920
		sh = 1080
		cw = 640
		ch = 480

		Pd.create('/tmp/tuto.pd', (sw-cw)/2, (sh-ch)/2, cw, ch, 12)

		Pd.canvas('tuto.pd', 0, 0, 300, 400, "cs", "rs", "Welcome to it !\nnew line :D\n:D:D\n:D:D:D")
		
		# Pd << "pd-tuto.pd obj 10 10 cnv 150 100 450 cs cr welcome\\ to\\ the\\ great\\ tutorial\\\n:D!\\\n:D!\\\n:D!\\\n:D!\\\n:D! 20 120 0 14 -233017 -66577 0"

		10.times do |i|
			sleep 0.3
			Pd.obj('tuto.pd', 'lop~', 350, 100 + i * 30, i * 100 + 110)
		end

		9.times do |i|
			sleep 0.3
			Pd.connect('tuto.pd', 1 + i, 0, 2 + i, 0)
		end

	end

end

end