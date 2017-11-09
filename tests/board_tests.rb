require 'simplecov'
SimpleCov.start

require 'codecov'
SimpleCov.formatter = SimpleCov::Formatter::Codecov

require_relative '../lib/board'
require 'test/unit'

class TestBoard < Test::Unit::TestCase
  def setup
    @board = Board.new
    @grid1 = [[:Empty, :Empty, :Empty, :Empty, :Empty, :Empty, :Empty, :Empty],
              [:Empty, :Empty, :Empty, :Empty, :Empty, :Empty, :Empty, :Empty],
              [:Empty, :Empty, :Empty, :Empty, :Empty, :Empty, :Empty, :Empty],
              [:Empty, :Empty, :Empty, :Black, :Empty, :Empty, :Empty, :Empty],
              [:Empty, :White, :Empty, :Empty, :White, :Empty, :Black, :Empty],
              [:Empty, :Empty, :Empty, :Empty, :Empty, :Empty, :Empty, :Empty],
              [:Empty, :Empty, :Empty, :Empty, :Empty, :Empty, :Empty, :Empty],
              [:Empty, :Empty, :Empty, :Empty, :Empty, :Empty, :Empty, :Empty]]
  end

   def test_direction
     assert_equal([:Empty, :Empty, :White, :Empty], @board.direction(@grid1, -1, 0, 4, 4))
   end

   def test_all_direction_arrays
     assert_equal([[:Black, :Empty, :Empty, :Empty],
                   [:Empty, :Empty, :White, :Empty],
                   [:Empty, :Empty, :Empty],
                   [:Empty, :Empty, :Empty, :Empty],
                   [:Empty, :Empty, :Empty],
                   [:Empty, :Empty, :Empty],
                   [:Empty, :Black, :Empty],
                   [:Empty, :Empty, :Empty]], @board.directions(@grid1, 4, 4))
   end

#   # I could not find a way to test valid_directions, is_valid_direction, change_pieces, or change_all_pieces

#   def test_count_pieces
#     @board.count_pieces
#     assert_equal(2, @board.white_count)
#     assert_equal(2, @board.black_count)
#   end

#   def test_count
#     space = Space.new($window)
#     space.state = :Black
#     @board.count(space)
#     assert_equal(1, @board.black_count)
#   end

#   def test_valid_move?
#     assert_equal(true, @board.valid_move?(:Black, 2, 3))
#     assert_not_equal(true, @board.valid_move?(:Black, 5, 3))
#   end

#   def test_possible_move
#     assert_equal(true, @board.possible_move(2, 3, :Black))
#   end

#   def test_possible_moves
#     assert_equal(true, @board.possible_moves(:Black))
#   end

#   def test_no_moves_left
#     assert_equal(false, @board.no_moves_left(:Black))
#   end
end
