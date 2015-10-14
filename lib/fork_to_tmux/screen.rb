#!/usr/bin/env ruby
pipe_name = ARGV[0]
File.open(pipe_name, "w+") do |file|
  file.puts(Process.pid)
  file.puts(`tty`)
end

system("stty sane")

STDIN.close
STDOUT.close

trap('SIGTERM') { exit }
IO.select([])
