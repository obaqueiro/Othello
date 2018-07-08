require 'simplecov'
SimpleCov.start

require 'codecov'
require 'codacy-coverage'
SimpleCov.formatter = SimpleCov::Formatter::Codecov
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
                                                                 SimpleCov::Formatter::HTMLFormatter,
                                                                 Codacy::Formatter,
                                                                 SimpleCov::Formatter::Codecov
                                                               ])
require 'test/unit'

SimpleCov.start 'rails' do
  add_filter '/tests/'
end

# SimpleCov.start do
#   # e.g., usage of track files
#   track_files "../**/*.rb"
# end

require 'test/unit'
require_relative '../lib/board'
require_relative '../lib/game'

