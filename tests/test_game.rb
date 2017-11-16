require 'simplecov'
SimpleCov.start

require 'codecov'
SimpleCov.formatter = SimpleCov::Formatter::Codecov

require_relative '../lib/game'
require 'test/unit'


class TestGame < Test::Unit::TestCase
  def setup
    @player1 = {Name: "Jeff", Color: :Black}
    @player2 = {Name: "Lily", Color: :White}
    @game = Game.new(@player1, @player2)

    @board1= [[:Empty, :Empty, :Empty, :Empty, :Empty, :Empty, :Empty, :Empty],
              [:Empty, :Empty, :Empty, :Empty, :Empty, :Empty, :Empty, :Empty],
              [:Empty, :Empty, :Empty, :Empty, :Empty, :Empty, :Empty, :Empty],
              [:Empty, :Empty, :Empty, :White, :Black, :Empty, :Empty, :Empty],
              [:Empty, :Empty, :Empty, :Black, :Black, :Empty, :Empty, :Empty],
              [:Empty, :Empty, :Empty, :Empty, :Black, :Empty, :Empty, :Empty],
              [:Empty, :Empty, :Empty, :Empty, :Empty, :Empty, :Empty, :Empty],
              [:Empty, :Empty, :Empty, :Empty, :Empty, :Empty, :Empty, :Empty]]
  end

  def test_move_happy_path
    @game.move(4,5)
    assert_equal(@board1, @game.board)
    assert_equal(@player2, @game.current_player)
  end

  def test_move_cell_already_occupied
    assert_raise(InvalidMove) {
      @game.move(4,4)
    }
  end
end
