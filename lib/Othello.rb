require 'gosu'
require_relative 'board'
require_relative 'player'
class Game < Gosu::Window
  attr_accessor :window

  def initialize
    @window_height = 450
    @window_width = 400
    super(@window_width, @window_height, false)
    self.caption = 'Othello'
    new_game
  end

  def update
    skip_turn(@player1, @player2, @current_turn)
    return_text_from_input
  end

  def return_text_from_input
    @text = if @input == text_input
              @input.text
            else
              ''
            end
  end

  def skip_turn(player1, player2, current_turn)
    if (player1.color == current_turn) && @board.no_moves_left(player1.color)
      switch_turns(current_turn)
    elsif (player2.color == current_turn) && @board.no_moves_left(player2.color)
      switch_turns(current_turn)
    end
  end

  def needs_cursor?
    true
  end

  def text_image(text)
    Gosu::Image.from_text(self, text, 'Times New Roman', 20)
  end

  def button_down(id)
    case id
    when Gosu::MsLeft
      if need_mouse
        player_turn(@player1, @player2, @current_turn)
        end_game?(@player1, @player2)
      end
    when Gosu::KbR
      reset if need_close_or_reset
    when Gosu::KbC
      close if need_close_or_reset
    when Gosu::KbReturn
      if need_text_input
        if @current_turn == @player1.color
          @player1.set_player_name(@input.text)
          @input.text = ''
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
    ((@input != text_input) && (@end_of_game == false))
  end

  def need_close_or_reset
    @input != text_input
  end

  def need_text_input
    @input == text_input
  end

  def player_turn(player1, player2, current_turn)
    if player1.color == current_turn
      select_space(player1.color, current_turn)
    else
      select_space(player2.color, current_turn)
    end
  end

  def select_space(color, current_turn)
    mouse_position
    if	@board.is_valid_move?(color, @x, @y)
      valid_move(color, @x, @y, current_turn)
    else
      invalid_move
    end
  end

  def valid_move(color, mouse_x, mouse_y, current_turn)
    @board.make_move(color, mouse_x, mouse_y)
    @show_invalid_move = false
    switch_turns(current_turn)
  end

  def invalid_move
    @show_invalid_move = true
  end

  def mouse_position
    @x = (mouse_x / 50).floor
    @y = ((mouse_y / 50) - 1).floor
  end

  def switch_turns(current_turn)
    @current_turn = if current_turn == :Black
                      :White
                    else
                      :Black
                    end
  end

  def end_game?(player1, player2)
    end_game(player1, player2) if is_it_endgame(player1, player2)
  end

  def is_it_endgame(player1, player2)
    (@board.no_moves_left(player1.color) && @board.no_moves_left(player2.color))
  end

  def end_game(player1, player2)
    final_score
    check_win(player1, player2)
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

  def check_win(player1, player2)
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
    @win = 'Tie'
  end

  def reset
    new_game
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
      Window: self,
      Color: :Black
    )
    @player2 = Player.new(
      Window: self,
      Color: :White
    )
  end

  def create_board
    @board = Board.new(self)
  end

  def new_game_conditions
    @current_turn = :Black
    @win = ''
    @end_of_game = false
    text_input_on
    show_only_player_info
  end

  def create_text_images
    @reset_game = Gosu::Image.from_text(self, 'Press R to reset game', 'Times New Roman', 20, 0, 100, :center)
    @close_game = Gosu::Image.from_text(self, 'Press C to close game.', 'Times New Roman', 20, 0, 100, :center)
    @invalid_move = text_image('Sorry Invalid Move')
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
    which_player_to_draw(player) if @show_player == true
  end

  def draw_player_info
    if @show_player_info == true
      if @current_turn == @player1.color
        info = text_image("Your color is #{@player1.color}. \nName: #{@text}")
        info.draw(((@window_width / 2) - (info.width / 2)), 0, 0)
      else
        info = text_image("Your color is #{@player2.color}. \nName: #{@text}")
        info.draw((@window_width / 2) - (info.width / 2), 0, 0)
      end
    end
  end

  def draw_reset_game
    @reset_game.draw(0, 0, 0) if @show_reset_game == true
  end

  def draw_close_game
    if @show_close_game == true
      @close_game.draw(@window_width - @close_game.width, 0, 0)
    end
  end

  def draw_invalid_move
    if @show_invalid_move == true
      @invalid_move.draw(middle_of_screen(@invalid_move), @invalid_move.height, 0)
    end
  end

  def draw_win
    if @show_win == true
      display_win = text_image(@win)
      display_win.draw(middle_of_screen(display_win), 0, 0)
    end
  end

  def draw_score
    if @show_score == true
      @score.draw(middle_of_screen(@score), @score.height, 0)
    end
  end

  def draw_current_turn
    if @show_turn == true
      turn = text_image(@current_turn.to_s)
      turn.draw(middle_of_screen(turn), 0, 0)
    end
  end

  def middle_of_screen(image)
    (@window_width / 2) - (image.width / 2)
  end

  def which_player_to_draw(player)
    if player.color == :Black
      player.draw_tag(x: 0,
                      y: 0,
                      z: 0)
    elsif player.color == :White
      player.draw_tag(x: @window_width - @player2.tag.width,
                      y: 0,
                      z: 0)
    end
  end
end
