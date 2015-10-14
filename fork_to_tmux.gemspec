lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fork_to_tmux/version'

Gem::Specification.new do |spec|
  spec.name          = "fork_to_tmux"
  spec.version       = ForkToTmux::VERSION
  spec.authors       = ["Florian Weingarten"]
  spec.email         = ["flo@hackvalue.de"]

  spec.summary       = "Execute Ruby code in a forked process attached to a tmux window"
  spec.homepage      = "https://github.com/fw42/fork-to-tmux"
  spec.license       = "MIT"

  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
end
