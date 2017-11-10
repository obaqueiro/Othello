class Board
  attr_accessor :white_count, :black_count

  def initialize
    make_grid
    othello_board_start
  end

  def make_grid
    @grid = Array.new(8) { Array.new(8) { :Empty } }
  end

  def othello_board_start
    @grid[3][3] = :White
    @grid[4][4] = :White
    @grid[3][4] = :Black
    @grid[4][3] = :Black
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

  def valid_directions?(grid, x, y, color)
    array = directions(grid, x, y).map { |direction| valid_direction?(color, direction)}
    array.include?(true)
  end


  def change_pieces_inline(direction, color)
    direction.map {|piece|
      if piece != color && piece != :Empty
        color
      else
        piece
      end
    }
  end

  def change_all_pieces(directions, color)
    directions.map { |direction|
      if valid_direction?(color, direction)
        change_pieces_inline(direction, color)
      else
        direction
      end
    }
  end

  def merge_changes(grid, directions, x, y)
    i = 0
    for dx in (-1..1)
      for dy in (-1..1)
        unless dx.zero? && dy.zero?
          pos = [y + dy, x + dx]
          directions[i].each { |space| 
            grid[pos[0]][pos[1]] = space
            pos = add_delta(dx, dy, pos)
          }
          i += 1
        end
      end
    end
    grid
  end

  def count_pieces(grid)
    pieces = {Black: 0, White: 0 }
    grid.flatten.reduce(pieces) do |accumulator, element|
      if(element != :Empty)
        accumulator[element] += 1
      end
      accumulator
    end
  end

  def valid_move?(color, x, y, grid)
    grid[y][x] == :Empty && valid_directions?(grid, x, y, color)
  end


  def moves_possible?(grid, color)
    for x in (0..7)
      for y in (0..7)
        return true if valid_move?(color, x, y, grid)
      end
    end
    false
  end

  def place_piece(grid, color, x, y)
    grid[y][x] = color
    merge_changes(grid, change_all_pieces(directions(grid, x, y), color), x, y)
  end
end
