## Fork to tmux

`fork` Ruby code and attach input/output to a tmux window.

Pretty hacky, but kinda works. Use at own risk.

No tests, because testing this shit is hard. Sorry.

### Installation

`gem install fork_to_tmux`

### Example

```ruby
require 'fork_to_tmux'

ForkToTmux.new do |session|
  w1 = session.split_window do |session|
    session.split_window(horizontal: true) do
      loop do
        puts Time.now
        sleep 1
      end
    end

    loop do
      puts Time.now
      sleep 0.25
    end
  end

  w2 = session.split_window(horizontal: true) do
    i = 0
    loop do
      puts Time.now
      sleep 0.25
    end
  end

  w1.wait
  w2.wait

  w3 = session.split_window do
    loop do
      puts Time.now
      sleep 0.1
    end
  end

  loop do
    puts Time.now
    sleep 1.5
  end

  w3.wait
end
```
