require 'securerandom'
require 'fileutils'

class ForkToTmux
  attr_reader :session_name

  def initialize(session_name = nil, &block)
    @session_name = session_name || "fork_to_tmux_#{SecureRandom.hex}"

    if block_given?
      new_session(&block).wait
    end
  end

  def split_window(horizontal: false, &block)
    cmd = "split-window -t #{session_name}"
    cmd << " -h" if horizontal
    self.class.new(session_name).new_tmux(cmd, &block)
  end

  def wait
    return unless @pid
    Process.waitpid(@pid)
  end

  def new_session(&block)
    new_tmux("new-session -s #{session_name}", &block)
  end

  def new_tmux(cmd)
    screen_pid, screen_tty = fork_tmux_screen(cmd)

    @pid = fork do
      STDIN.reopen(screen_tty)
      STDOUT.reopen(screen_tty)

      begin
        yield(self)
      rescue Errno::EIO
      end

      begin
        Process.kill('TERM', screen_pid)
      rescue Errno::ESRCH
      end
    end

    self
  end

  private

  def fork_tmux_screen(cmd)
    screen_pipe_name = "/tmp/fork_to_tmux_pipe_#{SecureRandom.hex}"
    system("mkfifo #{screen_pipe_name}")

    fork do
      system("tmux #{cmd} \"#{tmux_screen_script_filename} #{screen_pipe_name}\"")
    end

    screen_pipe = File.open(screen_pipe_name, 'r+')
    begin
      screen_pid = screen_pipe.gets.chomp.to_i
      screen_tty = screen_pipe.gets.chomp
    ensure
      screen_pipe.close
      FileUtils.rm(screen_pipe_name)
    end

    return screen_pid, screen_tty
  end

  def tmux_screen_script_filename
    File.expand_path("../fork_to_tmux/screen.rb", __FILE__)
  end
end
