require 'readline'
require 'socket'      # Sockets are in standard library

def server(&block)

	hostname = 'localhost'
	port = 2000

	ts = TCPSocket.new(hostname, port)
	
	yield ts
	
	s.close
end

Readline.completion_append_character = " "
Readline.completion_proc = proc do |s| 
	
	cmds = Readline.line_buffer.split(" ")

	list = case 
	when cmds.size <= 0 then ["object", "connect"]
	when cmds.size <= 2 then
		case cmds.first
		when 'object' then ['float', 'bang']
		when 'connect' then ['obj1', 'obj2', 'obj3']
		else ["object", "connect"]
		end
	end || []

	list.grep(/^#{Regexp.escape(s)}/) 
end

server do |s|
	while line = Readline.readline('Pd> ', true)
		s.puts(line)
		cmds = line.split(" ")
		p cmds
	end
end