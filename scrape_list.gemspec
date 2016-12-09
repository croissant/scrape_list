# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'scrape_list/version'

Gem::Specification.new do |spec|
  spec.name          = 'scrape_list'
  spec.version       = ScrapeList::VERSION
  spec.authors       = ['croissant']
  spec.email         = ['omelette@pomme.bona.jp']

  spec.summary       = %q{scrape list contents.}
  spec.description   = %q{scrape list contents.}
  spec.homepage      = ''

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'mechanize', '~> 2.7'
  spec.add_dependency 'concurrent-ruby', '~> 1.0'
  spec.add_dependency 'activesupport', '~> 4'

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 11.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'webmock', '~> 2.0'
end
