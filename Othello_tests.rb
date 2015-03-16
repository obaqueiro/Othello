require_relative "Othello.rb"
require "test/unit"
require "gosu"

$window = Gosu::Window.new(400,450,false)

class Test_Game < Test::Unit::TestCase
	
	def setup
		@game = Game.new
	end
	
	def teardown
	end
	
	def test_text_image
		assert_kind_of(Gosu::Image, @game.text_image("bob"))
	end
	
	def test_switch_turns
		assert_equal(:Black, @game.switch_turns(:White))
	end
	
	#I was not able to right tests for most of the methods because they change the states
	#of many objects
end

class Test_Board < Test::Unit::TestCase
	def setup
		@board = Board.new($window)
	end
	
	def teardown
	end
	
	def test_direction_array
		@test_direction_array_length = 7
		assert_equal(7, @board.direction_array(1,0,0,0).length)
		assert_equal(0,@board.direction_array(0,-1,0,0).length)
	end
	
	def test_all_direction_arrays
		assert_equal(8, @board.all_direction_arrays(5,5).length)
	end
	
	#I could not find a way to test valid_directions, is_valid_direction, change_pieces, or change_all_pieces
	
	def test_count_pieces
		@board.count_pieces
		assert_equal(2,@board.white_count)
		assert_equal(2,@board.black_count)
	end
	
	def test_count
		space = Space.new($window)
		space.set_contents(:Black)
		@board.count(space)
		assert_equal(1,@board.black_count)
	end
	
	def test_is_valid_move?
		assert_equal(true,@board.is_valid_move?(:Black,2,3))
		assert_not_equal(true, @board.is_valid_move?(:Black,5,3))
	end
	
	def test_possible_move
		assert_equal(true, @board.possible_move(2,3,:Black))
	end
	
	def test_possible_moves
		assert_equal(true, @board.possible_moves(:Black))
	end
	
	def test_no_moves_left
		assert_equal(false, @board.no_moves_left(:Black))
	end
end

class Test_Player < Test::Unit::TestCase
	def setup
		@player = Player.new(:Window=> $window, :Color => :Black)
	end
	
	def teardown
	end
	
	def test_set_player_name
		@player.set_player_name("jeff")
		assert_equal("jeff",@player.name)
		assert_kind_of(Gosu::Image, @player.tag)
	end
end

class Test_Space < Test::Unit::TestCase

	def setup
		@space = Space.new($window)
		@test_image = (Gosu::Image.new($window,"White_Circle.png",false))
	end
	
	def teardown
	end
	
	def test_new_image
		assert_kind_of(Gosu::Image, @space.new_image("White_Circle.png"))
	end

	def test_get_contents
		assert_equal(:Empty, @space.get_contents)
	end
end