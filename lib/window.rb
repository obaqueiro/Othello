require 'gosu'
require_relative 'board'
require_relative 'game'

class TextImage
  def initialize(text, line_height, options = {})
    @text = text
    @line_height = line_height
    @options = options
    @image = Gosu::Image.from_text(@text, @line_height, @options)
  end

  def text=(text)
    @text = text
    @image = Gosu::Image.from_text(@text, @line_height, @options)
  end

  def width
    @image.width
  end

  def draw(x, y, z, scale_x = 1, scale_y = 1, color = 0xff_ffffff, mode = :default)
    @image.draw(x, y, z, scale_x, scale_y, color, mode)
  end
end

class Window < Gosu::Window
  def initialize
    @window_height = 450
    @window_width = 400
    super(@window_width, @window_height, false)
    self.caption = 'Othello'

    @input = Gosu::TextInput.new
    @prompts = {
      Left: TextImage.new('', 20, align: :center, width: 133),
      Center: TextImage.new('', 20, align: :center, width: 134),
      Right: TextImage.new('', 20, align: :center, width: 133)
    }

    @board = Array.new(8) { Array.new(8) { :Empty } }

    @images = { White: Gosu::Image.new(File.expand_path('images/White_Circle.png'), false),
                Black: Gosu::Image.new(File.expand_path('images/Black_Circle.png'), false),
                Empty: Gosu::Image.new(File.expand_path('images/Empty_Space.png'), false) }

    @settings = {
      input: false
    }
    @current_player = 'Black'
    info_state
  end

  def mouse_position
    x = (mouse_x / 50).floor
    y = ((mouse_y / 50) - 1).floor
    { x: x, y: y }
  end

  def needs_cursor?
    true
  end

  def button_up(id)
    case id
    when Gosu::MsLeft
      begin
        pos = mouse_position
        @game.move(pos[:x], pos[:y])
        @prompts[:Center].text = @game.current_player[:Color]
        end_game_state if @game.game_over?
      rescue InvalidMove => e
        @prompts[:Center].text = "#{@game.current_player[:Color]}\n#{e}"
      end

    when Gosu::KbR
      reset unless @settings[:Input]
    when Gosu::KbC
      close unless @settings[:Input]
    when Gosu::KbReturn
      if @settings[:Input]

        if @current_player == 'Black'
          @player1 = { Name: @input.text, Color: :Black }
          @current_player = 'White'
          @input.text = ''
        else
          @player2 = { Name: @input.text, Color: :White }
          @current_player = 'White'

          @settings[:Input] = false
          self.text_input = nil
          @input.text = ''
          @prompts[:Center].text = ''

          @game = Game.new(@player1, @player2, Board.new)
          playing_state
        end
      end

    when Gosu::KbBackspace
      close
    end
  end

  def update
    # Required for input to be displayed in real time
    @prompts[:Center].text = "Your color is #{@current_player}. \nName: #{@input.text}" if @settings[:Input]
  end

  def draw
    draw_board
    @prompts[:Right].draw(right_of_screen(@prompts[:Right].width), 0, 0)
    @prompts[:Left].draw(0, 0, 0)
    @prompts[:Center].draw(middle_of_screen(@prompts[:Center].width), 0, 0)
  end

  def right_of_screen(length)
    @window_width - length
  end

  def middle_of_screen(length)
    (@window_width / 2) - (length / 2)
  end

  def reset
    info_state
  end

  def playing_state
    @current_player = 'Black'
    @prompts[:Left].text = "#{@player1[:Name]}: #{@player1[:Color]}"
    @prompts[:Right].text = "#{@player2[:Name]}: #{@player2[:Color]}"
    @prompts[:Center].text = @current_player
  end

  def info_state
    @current_player = 'Black'
    @prompts[:Left].text = ''
    @prompts[:Right].text = ''
    @settings[:Input] = true
    self.text_input = @input
  end

  def end_game_state
    @score = @game.score
    @winner = @game.winner

    @prompts[:Left].text = 'Press R to reset game'
    @prompts[:Right].text = 'Press C to close game'
    @prompts[:Center].text = "Black: #{@score[:Black]} White: #{@score[:White]}\nWinner: #{@winner}"
  end

  def draw_board
    for x in (0..7)
      for y in (0..7)
        draw_space(x, y, @game.grid[y][x]) if @game
      end
    end
  end

  def draw_space(x, y, space)
    @images[space].draw(x * 50, (1 + y) * 50, 0)
  end
end

win = Window.new
win.show
