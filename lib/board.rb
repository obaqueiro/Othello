require_relative 'space'

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
    @grid = Array.new(8) { Array.new(8) { Space.new(@window) } }
  end

  def direction_array(dx, dy, x, y)
    @pos_x = x + dx
    @pos_y = y + dy
    @direction_array = []
    until (@pos_x > 7) || (@pos_x < 0) || (@pos_y > 7) || (@pos_y < 0)
      @direction_array.push(@grid[@pos_x][@pos_y])
      add_delta_to_pos(dx, dy)
    end

    @direction_array
  end

  def add_delta_to_pos(delta_x, delta_y)
    @pos_x += delta_x
    @pos_y += delta_y
  end

  def all_direction_arrays(pos_x, pos_y)
    @all_direction_arrays = []
    for dx in (-1..1)
      for dy in (-1..1)
        @all_direction_arrays.push(direction_array(dx, dy, pos_x, pos_y)) unless dx.zero? && dy.zero?
      end
    end
    @all_direction_arrays
  end

  def valid_directions(pos_x, pos_y, player_color)
    all_direction_arrays(pos_x, pos_y).each	do |direction_array|
      return true if valid_direction?(player_color, direction_array)
    end
    false
  end

  def valid_direction?(player_color, direction_array)
    seen_opp_color = false
    direction_array.each	do |space|
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

  def change_pieces(player_color, direction_array)
    opp_color = player_color == :White ? :Black : :White
    direction_array.each	do |space|
      break unless opp_color == space.state
      space.state = player_color
    end
  end

  def change_all_pieces(pos_x, pos_y, player_color)
    all_direction_arrays(pos_x, pos_y).each	do |direction_array|
      if valid_direction?(player_color, direction_array)
        change_pieces(player_color, direction_array)
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
    @grid[3][3].state= :White
    @grid[4][4].state= :White
    @grid[3][4].state= :Black
    @grid[4][3].state= :Black
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
