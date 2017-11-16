require 'simplecov'
SimpleCov.start

require 'codecov'
SimpleCov.formatter = SimpleCov::Formatter::Codecov

require_relative '../lib/game'
require 'test/unit'


class TestGame < Test::Unit::TestCase
  def setup
    @game = Game.new({Name: "Jeff", Color: :Black}, {Name: "Lily", Color: :Whitss})
  end

  def place_piece_valid
  end
end