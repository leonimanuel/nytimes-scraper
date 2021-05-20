require_relative 'lib/ny_times_search/version'

Gem::Specification.new do |spec|
  spec.name          = "ny_times_searcher"
  spec.version       = NyTimesSearch::VERSION
  spec.authors       = ["LIManuel"]
  spec.email         = ["leonmalisov@gmail.com"]

  spec.summary       = %q{Scrapes the NY Times website for a given keyword search}
  # spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "https://github.com/leonimanuel/nytimes-scraper"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "http://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/leonimanuel/nytimes-scraper"
  # spec.metadata["changelog_uri"] = "https://github.com/leonimanuel/nytimes-scraper/blob/master/CHANGEDOC.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  #ADD DEPENDENCIES
  spec.add_dependency "activesupport", "4.2.0"
  spec.add_dependency "rake", "~> 12.0"
  spec.add_dependency 'pry'
  spec.add_dependency 'nokogiri', '1.10.10'
  spec.add_dependency "colorize"
end
