require 'simplecov'
SimpleCov.start

require 'codecov'
SimpleCov.formatter = SimpleCov::Formatter::Codecov

SimpleCov.start do
  # e.g., usage of track files
  track_files "/app/**/*.rb"
end
