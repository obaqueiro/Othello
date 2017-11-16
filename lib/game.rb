require_relative 'board'

class InvalidMove < StandardError
  def initialize(msg = 'Invalid Move')
    super
  end
end

class Game
  attr_reader :board
  def initialize(player1, player2, board)
    @board = board
    @players = [player1, player2]
    # new_game
  end

  def grid
    @board.grid
  end

  def current_player
    @players[0]
  end

  def move(x, y)
    if valid_move?(x, y, @board, current_player[:Color])
      @board.place(x, y, current_player[:Color])
      @players.reverse! if moves_left?(@board, @players[1][:Color])
    else
      raise InvalidMove
    end
  end

  def moves_left?(board, color)
    array = []
    for x in (0..7)
      for y in (0..7)
        array.push(valid_directions?(x, y, board, color))
      end
    end
    array.include?(true)
  end

  def valid_move?(x, y, board, color)
    grid[y][x] == :Empty && valid_directions?(x, y, board, color)
  end

  def valid_directions?(x, y, board, color)
    array = board.directions(board.grid, x, y).map { |direction| valid_direction?(color, direction)}
    array.include?(true)
  end

  def valid_direction?(color, direction)
    opp_color = false
    direction.each	do |space|
      if space == :Empty
        return false
      elsif space == color
        return opp_color
      else
        opp_color = true
      end
    end
    false
  end

  def game_over?
    moves_left?(@board, :Black) && moves_left?(@board, :White)
  end

  def score
    board.pieces
  end

  def winner
    if(score[@players[0][:Color]] > score[@players[1][:Color]])
      return @players[0][:Name]
    elsif(score[@players[0][:Color]] < score[@players[1][:Color]])
      return @players[1][:Name]
    else
      return :Tie
    end
  end
end
