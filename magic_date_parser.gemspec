# -*- encoding: utf-8 -*-
require File.expand_path('../lib/magic_date_parser/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Substantial"]
  gem.description   = %q{Parses a string representation of a date range and returns a start and end date.}
  gem.summary       = %q{Parses a string representation of a date range (for example, "December 4 - 7, 1969") and
                         and returns a list containing a start date and end date.}
  gem.homepage      = "https://github.com/substantial/magic-date-parser"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "magic_date_parser"
  gem.require_paths = ["lib"]
  gem.version       = MagicDateParser::VERSION
end
