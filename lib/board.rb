require_relative 'space'

class Board
  attr_accessor :white_count, :black_count

  def initialize
    @white_count = 0
    @black_count = 0
    make_grid
    othello_board_start
  end

  def make_grid
    @grid = Array.new(8) { Array.new(8) { :Empty } }
  end

  def direction(grid, dx, dy, x, y)
    pos = [y + dy, x + dx]
    array = []
    until (pos[0] > 7) || (pos[0] < 0) || (pos[1] > 7) || (pos[1] < 0)
      array.push(grid[pos[0]][pos[1]])
      pos = add_delta(dx, dy, pos)
    end
    array
  end

  def add_delta(dx, dy, pos)
    [pos[0] + dy, pos[1] + dx]
  end

  def directions(grid, x, y)
    array = []
    for dx in (-1..1)
      for dy in (-1..1)
        array.push(direction(grid, dx, dy, x, y)) unless dx.zero? && dy.zero?
      end
    end
    array
  end

  def valid_directions(pos_x, pos_y, player_color)
    all_directions(pos_x, pos_y).each	do |direction_array|
      return true if valid_direction?(player_color, direction)
    end
    false
  end

  def valid_direction?(player_color, direction)
    seen_opp_color = false
    direction.each	do |space|
      content = space.state
      if content == :Empty
        return false
      elsif content == player_color
        if seen_opp_color
          return true
        else
          return false
        end
      else
        seen_opp_color = true
      end
    end
    false
  end

  def change_pieces(player_color, direction)
    opp_color = player_color == :White ? :Black : :White
    direction.each	do |space|
      break unless opp_color == space.state
      space.state = player_color
    end
  end

  def change_all_pieces(pos_x, pos_y, player_color)
    all_directions(pos_x, pos_y).each	do |direction_array|
      if valid_direction?(player_color, direction)
        change_pieces(player_color, direction)
      end
    end
  end

  def count_pieces
    @grid.each { |x_space| x_space.each { |y_space| count(y_space) } }
  end

  def count(space)
    if space.state == :White
      @white_count += 1
    elsif space.state == :Black
      @black_count += 1
    end
  end

  def othello_board_start
    @grid[3][3] = :White
    @grid[4][4] = :White
    @grid[3][4] = :Black
    @grid[4][3] = :Black
    # test board end game
    # @grid[1][0].state(:Black)
    # @grid[0][0].state(:White)
  end

  def draw_board
    for x in (0..7)
      for y in (0..7)
        @grid[x][y].draw_space(x, y)
      end
    end
  end

  def valid_move?(color, x, y)
    @grid[x][y].state == :Empty && valid_directions(x, y, color)
  end

  def make_move(color, x, y)
    @grid[x][y].state = color
    change_all_pieces(x, y, color)
  end

  def possible_move(x, y, player_color)
    (@grid[x][y].state == :Empty) && valid_directions(x, y, player_color)
  end

  def possible_moves(player_color)
    for x in (0..7)
      for y in (0..7)
        return true if possible_move(x, y, player_color)
      end
    end
    false
  end

  def no_moves_left(player_color)
    if possible_moves(player_color)
      false
    else
      true
    end
  end
end
