require 'simplecov'
SimpleCov.start

require 'codecov'
SimpleCov.formatter = SimpleCov::Formatter::Codecov
require 'test/unit'

SimpleCov.start do
  # e.g., usage of track files
  track_files "../**/*.rb"
end
