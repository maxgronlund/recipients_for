# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'recipients_for/version'

Gem::Specification.new do |spec|
  spec.name          = "recipients_for"
  spec.version       = RecipientsFor::VERSION
  spec.authors       = ["Max Grønlund"]
  spec.email         = ["max@synthmax.dk"]

  spec.summary       = %q{Write messages on a model instance}
  spec.description   = %q{Select recipients and notification method for any model instance}
  spec.homepage      = "https://github.com/maxgronlund/recipients_for"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://github.com/maxgronlund/recipients_for"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]


  spec.add_dependency  'paperclip'

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency 'rails',  "~> 4.2.7"
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'awesome_print'
  spec.add_development_dependency "factory_girl", "~> 4.0"
  spec.add_development_dependency "faker"
end
