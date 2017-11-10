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

    @grid2 = [[:Empty, :Empty, :Empty, :Empty, :Empty, :Empty, :Empty, :Empty],
              [:Empty, :Empty, :Empty, :Empty, :Empty, :Empty, :Empty, :Empty],
              [:Empty, :Empty, :Empty, :Empty, :Empty, :Empty, :Empty, :Empty],
              [:Empty, :Empty, :Empty, :Black, :Empty, :Empty, :Empty, :Empty],
              [:Empty, :White, :Empty, :Empty, :Black, :Empty, :Black, :Empty],
              [:Empty, :Empty, :Empty, :Empty, :Empty, :Empty, :Empty, :Empty],
              [:Empty, :Empty, :Empty, :Empty, :Empty, :Empty, :Empty, :Empty],
              [:Empty, :Empty, :Empty, :Empty, :Empty, :Empty, :Empty, :Empty]]
  end

   def test_direction
     assert_equal([:Empty, :Empty, :White, :Empty], @board.direction(@grid1, -1, 0, 4, 4))
   end

   def test_directions
     assert_equal([[:Black, :Empty, :Empty, :Empty],
                   [:Empty, :Empty, :White, :Empty],
                   [:Empty, :Empty, :Empty],
                   [:Empty, :Empty, :Empty, :Empty],
                   [:Empty, :Empty, :Empty],
                   [:Empty, :Empty, :Empty],
                   [:Empty, :Black, :Empty],
                   [:Empty, :Empty, :Empty]], @board.directions(@grid1, 4, 4))
   end

   def test_valid_direction_empty_space
     assert(!@board.valid_direction?(:Black, [:Empty, :White]))
     assert(!@board.valid_direction?(:Black, [:White, :White, :Empty]))
   end

   def test_valid_direction
     assert(@board.valid_direction?(:Black, [:White, :White, :Black]))
   end

   def test_valid_directions
     assert(!@board.valid_directions?(@grid1, 4, 4, :Black))
     assert(@board.valid_directions?(@grid1, 5, 5, :Black))
   end

   def test_change_pieces_inline
     assert_equal([:White, :White, :White], @board.change_pieces_inline([:Black, :Black, :White], :White))
   end

   def test_change_all_pieces
     assert_equal([[:Black, :Black, :Black],
                   [:White, :Empty],
                   [:Empty, :Empty, :Empty, :Black]],
                  @board.change_all_pieces([[:White, :White, :Black],
                                            [:White, :Empty],
                                            [:Empty, :Empty, :Empty, :Black]], :Black))
   end

   def test_merge_changes
     assert_equal(@grid2,
                  @board.merge_changes(@grid1,
                                       [[:Black, :Black, :Empty, :Empty, :Empty],
                                        [:Empty, :Empty, :Empty, :Empty, :Empty],
                                        [:Empty, :Empty],
                                        [:Empty, :Empty, :Empty, :Empty, :Empty],
                                        [:Empty, :Empty],
                                        [:Black, :Empty],
                                        [:Empty, :Empty],
                                        [:Empty, :Empty]], 5, 5))
   end

  def test_count_pieces
    assert_equal({ Black: 3, White: 1 }, @board.count_pieces(@grid2))
  end

  def test_valid_move?
    assert(@board.valid_move?(:Black, 5, 5, @grid1))
    assert(!@board.valid_move?(:Black, 5, 3, @grid1))
  end

  def test_moves_possible?
    assert(@board.moves_possible?(@grid1, :Black))
    assert(!@board.moves_possible?(@grid2, :White))
  end

  def test_place_piece
    assert_equal(@grid2, @board.change_piece(@grid1, :Black, 5, 5))
  end
end
