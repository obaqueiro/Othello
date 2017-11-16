require_relative 'board'
class Game
  def initialize(player1, player2)
    @players = [player1, player2]
    @board = Board.new
    # new_game
  end

  def board
    @board.grid
  end

  def current_player
    @players[0]
  end

  def move(x, y)
    @board.place(x, y, current_player[:Color])
    @players.reverse!
  end

  def skip_turn(player1, player2, current_turn)
    if (player1.color == current_turn) && @board.no_moves_left(player1.color)
      switch_turns(current_turn)
    elsif (player2.color == current_turn) && @board.no_moves_left(player2.color)
      switch_turns(current_turn)
    end
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
    if	@board.valid_move?(color, @x, @y)
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


  def check_win(player1, player2)
    if @board.black_count > @board.white_count
      winner_text(player1.name)
    elsif @board.black_count == @board.white_count
      tie_text
    else
      winner_text(player2.name)
    end
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

  def create_board
    @board = Board.new(self)
  end
end
