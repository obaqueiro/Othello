require 'gosu'

class Game < Gosu::Window
	attr_accessor :window
	
    def initialize 
		@window_height = 450
		@window_width = 400
		super(@window_width, @window_height, false)
		self.caption = "Othello"
		new_game
    end
	
    def update
		skip_turn(@player1,@player2,@current_turn)
		return_text_from_input
    end
	
	def return_text_from_input
		if @input == self.text_input
			@text = @input.text
		else
			@text = ""
		end
	end
	
	def skip_turn(player1,player2,current_turn)
		if player1.color == current_turn and @board.no_moves_left(player1.color)
			switch_turns(current_turn)
		elsif player2.color == current_turn and @board.no_moves_left(player2.color)
			switch_turns(current_turn)
		end
	end
   
	def needs_cursor?
		true
	end
   
	def text_image(text)
		Gosu::Image.from_text(self, text, "Times New Roman",20)
	end
	
    def button_down(id)
		case id
		when Gosu::MsLeft
			if need_mouse
				player_turn(@player1,@player2,@current_turn)
				end_game?(@player1,@player2)
			end
		when Gosu::KbR
			if need_close_or_reset
				reset
			end
		when Gosu::KbC 
			if need_close_or_reset
				self.close
			end
		when Gosu::KbReturn 
			if need_text_input
				if @current_turn == @player1.color
					@player1.set_player_name(@input.text)
					@input.text = ""
					switch_turns(@current_turn)
				else
					@player2.set_player_name(@input.text)
					end_of_input_conditions
					switch_turns(@current_turn)
					end
			end
		end
	end
	
	def end_of_input_conditions
		@show_player_info = false
		@show_player = true
		@input = nil
		@show_turn = true
	end
	
	def text_input_on
		@input = Gosu::TextInput.new
		self.text_input = @input
	end
	
	def need_mouse
		(not @input == self.text_input and @end_of_game == false)
	end
	
	def need_close_or_reset
		not @input == self.text_input
	end
	
	def need_text_input
		@input == self.text_input
	end
	
	def player_turn(player1,player2,current_turn)
		if player1.color == current_turn
			select_space(player1.color,current_turn)
		else
			select_space(player2.color,current_turn)
		end
	end
	
	def select_space(color,current_turn)
		mouse_position
		if 	@board.is_valid_move?(color,@x,@y)
			valid_move(color,@x,@y,current_turn)
		else
			invalid_move
		end
	end
	
	def valid_move(color,mouse_x,mouse_y,current_turn)
		@board.make_move(color,mouse_x,mouse_y)
		@show_invalid_move = false
		switch_turns(current_turn)
	end
	
	def invalid_move
		@show_invalid_move = true
	end
	
	def mouse_position
		@x = (mouse_x/50).floor
		@y = ((mouse_y/50)-1).floor
	end
	
	def switch_turns(current_turn)
		if current_turn == :Black
			@current_turn = :White
		else
			@current_turn = :Black
		end
	end
	
	def end_game?(player1,player2)
		if	is_it_endgame(player1,player2)
			end_game(player1,player2)
		end
	end
	
	def is_it_endgame(player1,player2)
		(@board.no_moves_left(player1.color) and @board.no_moves_left(player2.color))
	end
	
	def end_game(player1,player2)
		final_score
		check_win(player1,player2)
		end_game_conditions
	end
	
	def end_game_conditions
		@show_close_game = true
		@show_reset_game = true
		@show_player = false
		@end_of_game = true
		@show_win = true
		@show_turn = false
	end
	
	def final_score
		@board.count_pieces
		@show_score = true
		@score = text_image("Black #{@board.black_count} White #{@board.white_count}")
	end
	
	def check_win(player1,player2)
		if @board.black_count > @board.white_count
			winner_text(player1.name)
		elsif @board.black_count == @board.white_count
			tie_text
		else
			winner_text(player2.name)
		end
	end
		
	def winner_text(winner)
		@win = "#{winner} Wins"
	end
		
	def tie_text
		@win = "Tie"
	end
		
	def reset
		self.new_game
	end
  
	def new_game
		create_game_objects
		new_game_conditions
	end
	
	def create_game_objects
		create_players
		create_board
		create_text_images
	end
	
	def create_players
		@player1 = Player.new(
										:Window => self,
										:Color => :Black
									)
		@player2 = Player.new(
										:Window => self,
										:Color => :White
									)
	end
	
	def create_board
		@board = Board.new(self)
	end
	
	def new_game_conditions
		@current_turn = :Black
		@win = ""
		@end_of_game = false
		text_input_on
		show_only_player_info
	end
		
	def create_text_images
		@reset_game = Gosu::Image.from_text(self,"Press R to reset game","Times New Roman",20,0,100,:center)
		@close_game = Gosu::Image.from_text(self,"Press C to close game.","Times New Roman",20,0,100,:center)
		@invalid_move = text_image("Sorry Invalid Move")
	end
		
	def show_only_player_info
		@show_score = false
		@show_win = false
		@show_turn = false
		@show_invalid_move = false
		@show_close_game = false
		@show_reset_game = false
		@show_player_info = true
		@show_player = false
	end
	
	def draw
		draw_player(@player1)
		draw_player(@player2)
		draw_board
		draw_current_turn
		draw_score
		draw_win
		draw_invalid_move
		draw_close_game
		draw_reset_game
		draw_player_info
    end
	
	def draw_board
		@board.draw_board
	end
	
	def draw_player(player)
		if @show_player == true
			which_player_to_draw(player)
		end
	end
	
	def draw_player_info
		if @show_player_info == true
			if @current_turn == @player1.color
				info = text_image("Your color is #{@player1.color}. \nName: #{@text}")
				info.draw(((@window_width/2)-(info.width/2)),0,0)
			else
				info = text_image("Your color is #{@player2.color}. \nName: #{@text}")
				info.draw((@window_width/2)-(info.width/2),0,0)
			end
		end
	end
	
	def draw_reset_game
		if @show_reset_game == true
			@reset_game.draw(0,0,0)
		end
	end
	
	def draw_close_game
		if @show_close_game == true
			@close_game.draw(@window_width-@close_game.width,0,0)
		end
	end
	
	def draw_invalid_move
		if @show_invalid_move == true
			@invalid_move.draw(middle_of_screen(@invalid_move),@invalid_move.height,0)
		end
	end
	
	def draw_win
		if @show_win == true
			display_win = text_image(@win)
			display_win.draw(middle_of_screen(display_win),0,0)
		end
	end
	
	def draw_score
		if @show_score == true
			@score.draw(middle_of_screen(@score),@score.height,0)
		end
	end
	
	def draw_current_turn
		if @show_turn == true
			turn = text_image("#{@current_turn}")
			turn.draw(middle_of_screen(turn),0,0)
		end
	end
	
	def middle_of_screen(image)
		(@window_width/2)-(image.width/2)
	end
	
	def which_player_to_draw(player)
		if player.color == :Black
				player.draw_tag(	:x => 0, 
											:y => 0,
											:z => 0)
		elsif player.color == :White
				player.draw_tag(	:x => @window_width-(@player2.tag.width), 
											:y => 0,
											:z => 0)
		end
	end
end

class Board
	attr_accessor :white_count, :black_count
	
	def initialize(window)
		@window = window
		@white_count = 0
		@black_count = 0
		make_grid
		othello_board_start
	end
	
	def make_grid
		@grid = Array.new(8) { Array.new(8) {Space.new(@window)}}
	end
	
	def direction_array(dx,dy, x, y)
		@pos_x = x +dx
		@pos_y = y +dy
		@direction_array = []
		until (@pos_x > 7 or @pos_x < 0 or @pos_y > 7 or @pos_y < 0)
			@direction_array.push(@grid[@pos_x][@pos_y])
			add_delta_to_pos(dx,dy)
		end
		
		return @direction_array
	end
	
	def add_delta_to_pos(delta_x,delta_y)
		@pos_x += delta_x
		@pos_y += delta_y
	end
	
	def all_direction_arrays(pos_x,pos_y)
		@all_direction_arrays = []
		for dx in (-1..1)
			for dy in (-1..1)
				@all_direction_arrays.push(direction_array(dx,dy,pos_x, pos_y)) unless (dx == 0 and dy == 0) 
			end
		end
		return @all_direction_arrays
	end
	
	def valid_directions(pos_x,pos_y,player_color)
		all_direction_arrays(pos_x,pos_y).each 	{ |direction_array| 
																		return true if is_valid_direction(player_color, direction_array) 
																	}
		return false
	end
	
	def is_valid_direction(player_color, direction_array)
		seen_opp_color = false
		direction_array.each 	{|space| 
												content = space.get_contents
												if content == :Empty
													return false
												elsif content == player_color
													if  seen_opp_color
														return true
													else 
														return false
													end
												else
													seen_opp_color = true
												end
									} 
		return false
	end
	
	def change_pieces(player_color, direction_array)
		opp_color = player_color == :White ? :Black : :White
		direction_array.each 	{|space| content = space.get_contents
												if content == :Empty
													break
												elsif content == opp_color
															space.set_contents(player_color)
												else 
													break
												end
									}
	end
	
	def change_all_pieces(pos_x,pos_y,player_color)
		all_direction_arrays(pos_x,pos_y).each 	{ |direction_array| 
																		if is_valid_direction(player_color, direction_array)
																			change_pieces(player_color,direction_array)
																		end
																	}
	end
	
	def count_pieces
		@grid.each {|x_space| x_space.each { |y_space| count(y_space)}}
	end
	
	def count(space)
		if space.get_contents == :White
			@white_count += 1
		elsif space.get_contents == :Black
			@black_count += 1
		end
	end
	
	def othello_board_start
		@grid[3][3].set_contents(:White)
		@grid[4][4].set_contents(:White)
		@grid[3][4].set_contents(:Black)
		@grid[4][3].set_contents(:Black)
		#test board end game
		#@grid[1][0].set_contents(:Black)
		#@grid[0][0].set_contents(:White)
	end
  
	def draw_board
		for x in (0..7)
			for y in (0..7)
				@grid[x][y].draw_space(x,y)
			end
		end
	end
	
	def is_valid_move?(color,x,y)
		if @grid[x][y].get_contents == :Empty && valid_directions(x,y,color)
			return true
		else 
			return false
		end
	end
	
	def make_move(color, x, y)
		@grid[x][y].set_contents(color)
		change_all_pieces(x,y,color)
	end
	
	def possible_move(x,y,player_color)
		if (@grid[x][y].get_contents == :Empty and valid_directions(x,y,player_color))
			return true
		end
	end
	
	def possible_moves(player_color)
		for x in (0..7)
			for y in (0..7)
				return true if possible_move(x,y,player_color)
			end
		end
		return false
	end
	
	def no_moves_left(player_color)
		if possible_moves(player_color)
			return false
		else 
			return true
		end
	end
end
	
class Player
    attr_accessor :name, :color, :tag
    
    def initialize(args)
		@args = args
		@color = @args[:Color]
		@window = @args[:Window]
		@name = ""
    end
	
	def set_player_name(text)
		@name = text
		@tag = Gosu::Image.from_text(@window, "#{@name} :#{@color}", "Times New Roman", 20)
	end
	
	def draw_tag(cor)
		@x = cor[:x]
		@y = cor[:y]
		@z = cor[:z]
		@tag.draw(	@x,
						@y,
						@z)
	end
end

class Space
	attr_accessor :window, :current_state, :image
  
	def initialize(window)
		 @window = window
		 @images = {:White => new_image("White_Circle.png"),
							:Black => new_image("Black_Circle.png"),
							:Empty => new_image("Empty_Space.png")
							}
		 @current_state = :Empty 
		 @image = @images[@current_state]
	end
  
	def new_image(filename)
		 Gosu::Image.new(@window, filename,false)
	end
	
	def get_contents
		return @current_state
	end
	
	def set_contents(state)
		@current_state = state
		@image = @images[state]
	end
	
	def draw_space(x,y)
		@image.draw(x*50,(1+y)*50,0)
	end
end

game = Game.new
game.show