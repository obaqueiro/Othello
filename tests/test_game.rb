require 'simplecov'
SimpleCov.start

require 'codecov'
SimpleCov.formatter = SimpleCov::Formatter::Codecov

require_relative '../lib/game'
require_relative '../lib/board'
require 'test/unit'


class TestGame < Test::Unit::TestCase
  def setup
    @board = Board.new
    @player1 = {Name: "Jeff", Color: :Black}
    @player2 = {Name: "Lily", Color: :White}
    @game = Game.new(@player1, @player2, @board)

    @grid1= [[:Empty, :Empty, :Empty, :Empty, :Empty, :Empty, :Empty, :Empty],
              [:Empty, :Empty, :Empty, :Empty, :Empty, :Empty, :Empty, :Empty],
              [:Empty, :Empty, :Empty, :Empty, :Empty, :Empty, :Empty, :Empty],
              [:Empty, :Empty, :Empty, :White, :Black, :Empty, :Empty, :Empty],
              [:Empty, :Empty, :Empty, :Black, :Black, :Empty, :Empty, :Empty],
              [:Empty, :Empty, :Empty, :Empty, :Black, :Empty, :Empty, :Empty],
              [:Empty, :Empty, :Empty, :Empty, :Empty, :Empty, :Empty, :Empty],
              [:Empty, :Empty, :Empty, :Empty, :Empty, :Empty, :Empty, :Empty]]
  end

  def test_move_happy_path
    @game.move(4, 5)
    assert_equal(@grid1, @game.grid)
    assert_equal(@player2, @game.current_player)
  end

  def test_move_cell_already_occupied
    assert_raise(InvalidMove) {
      @game.move(4, 4)
    }
  end

  def test_move_cell_not_adjacent_to_occupied_cell
    assert_raise(InvalidMove) {
      @game.move(5, 5)
    }
  end

    def test_valid_direction_empty_space
      assert(!@game.valid_direction?(:Black, [:Empty, :White]))
      assert(!@game.valid_direction?(:Black, [:White, :White, :Empty]))
    end

    def test_valid_direction
      assert(@game.valid_direction?(:Black, [:White, :White, :Black]))
    end

    def test_valid_directions
      assert(!@game.valid_directions?(4, 4, @board, :Black))
      assert(@game.valid_directions?(4, 5, @board, :Black))
    end
end
