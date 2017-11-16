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
    @board2 = Board.new
    @board3 = Board.new
    @board4 = Board.new
    @player1 = { Name: 'Jeff', Color: :Black }
    @player2 = { Name: 'Lily', Color: :White }
    @game = Game.new(@player1, @player2, @board)

    @grid1 = [%i[Empty Empty Empty Empty Empty Empty Empty Empty],
              %i[Empty Empty Empty Empty Empty Empty Empty Empty],
              %i[Empty Empty Empty Empty Empty Empty Empty Empty],
              %i[Empty Empty Empty White Black Empty Empty Empty],
              %i[Empty Empty Empty Black Black Empty Empty Empty],
              %i[Empty Empty Empty Empty Black Empty Empty Empty],
              %i[Empty Empty Empty Empty Empty Empty Empty Empty],
              %i[Empty Empty Empty Empty Empty Empty Empty Empty]]

    @grid2 = [%i[Empty Empty Empty Empty Empty Empty Empty Empty],
              %i[Empty Empty Empty Empty Empty Empty Empty Empty],
              %i[Empty Empty Empty Empty Empty Empty Empty Empty],
              %i[Empty Empty Empty Black Black Empty Empty Empty],
              %i[Empty Empty Empty Black White Empty Empty Empty],
              %i[Empty Empty Empty Empty Empty Empty Empty Empty],
              %i[Empty Empty Empty Empty Empty Empty Empty Empty],
              %i[Empty Empty Empty Empty Empty Empty Empty Empty]]

    @grid3 = [%i[Black Black Black Black Black Black Black Black],
              %i[Black Black Black Black Black Black Black White],
              %i[Black Black Black Black Black Black Black White],
              %i[Black Black Black Black Black Black Black White],
              %i[Black Black Black Black White Black Black White],
              %i[Black Black Black Black Black Black Black White],
              %i[Black Black Black Black Black Black Black White],
              %i[Black White White White White White White Empty]]

    @grid4 = [%i[Black Black Black Black Black Black Black Black],
              %i[Black Black Black Black Black Black Black Black],
              %i[Black Black Black Black Black Black Black Black],
              %i[Black Black Black Black Black Black Black Black],
              %i[Black Black Black Black White Black Black Black],
              %i[Black Black Black Black Black Black Black Black],
              %i[Black Black Black Black Black Black Black Black],
              %i[Black Black Black Black Black Black Black Black]]

    @board2.grid = @grid2
    @board3.grid = @grid3
    @game2 = Game.new(@player1, @player2, @board2)
    @game3 = Game.new(@player1, @player2, @board3)
  end

  def test_move_happy_path
    @game.move(4, 5)
    assert_equal(@grid1, @game.grid)
    assert_equal(@player2, @game.current_player)
  end

  def test_next_player_has_no_moves
    @game2.move(4, 5)
    assert_equal(@grid2, @game2.grid)
    assert_equal(@player1, @game2.current_player)
  end

  def test_move_cell_already_occupied
    assert_raise(InvalidMove) do
      @game.move(4, 4)
    end
  end

  def test_move_cell_not_adjacent_to_occupied_cell
    assert_raise(InvalidMove) do
      @game.move(5, 5)
    end
  end

  def test_move_game_over
    @game3.move(7,7)
    assert(@game3.game_over?)
  end

  def test_valid_direction_empty_space
    assert(!@game.valid_direction?(:Black, %i[Empty White]))
    assert(!@game.valid_direction?(:Black, %i[White White Empty]))
  end

  def test_valid_direction
    assert(@game.valid_direction?(:Black, %i[White White Black]))
  end

  def test_valid_directions
    assert(!@game.valid_directions?(4, 4, @board, :Black))
    assert(@game.valid_directions?(4, 5, @board, :Black))
  end

  def test_winner
    assert_equal(@player1[:Name], @game3.winner)
  end
end
