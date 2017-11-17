class Board
  attr_accessor :grid

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
    while (0..7).cover?(pos[0]) && (0..7).cover?(pos[1])
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
    (-1..1).each { |dx| 
      (-1..1).each { |dy| 
        array.push(direction(grid, dx, dy, x, y)) unless dx.zero? && dy.zero?
      }
    }
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
    seen_color = false
    direction.map { |piece|
      if piece == color
        seen_color = true
        piece
      elsif piece != :Empty && !seen_color
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
    (-1..1).each { |dx| 
      (-1..1).each { |dy| 
        unless dx.zero? && dy.zero?
          pos = [y + dy, x + dx]
          directions[i].each { |space| 
            grid[pos[0]][pos[1]] = space
            pos = add_delta(dx, dy, pos)
          }
          i += 1
        end
      }
    }
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

  def pieces
    count_pieces(@grid)
  end

  def valid_move?(color, x, y, grid)
    grid[y][x] == :Empty && valid_directions?(grid, x, y, color)
  end


  def moves_possible?(grid, color)
    array = []
    grid.each_with_index { |_, xi|
      _.each_with_index { |_, yi|
        array.push(valid_move?(color, xi, yi, grid))
      }
    }
    array.include?(true)
  end

  def place_piece(grid, color, x, y)
    grid[y][x] = color
    merge_changes(grid, change_all_pieces(directions(grid, x, y), color), x, y)
  end

  def place(x, y, color)
    @grid = place_piece(@grid, color, x, y)
  end
end
