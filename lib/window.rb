require 'gosu'
require_relative 'player'

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

  def button_down(id)
    case id
    when Gosu::MsLeft
      begin
        # TODO: Need to fix game core

        raise ArgumentError, 'Invalid Move'
        end_game_state
      rescue ArgumentError => e
        @prompts[:Center].text = "#{@current_player}\n#{e}"
      end

    when Gosu::KbR
      reset unless @settings[:Input]
    when Gosu::KbT
      end_game_state
    when Gosu::KbC
      close unless @settings[:Input]
    when Gosu::KbReturn
      if @settings[:Input]

        if @current_player == 'Black'
          @player1 = Player.new(
            Window: self,
            Name: @input.text,
            Color: 'Black'
          )
          @current_player = 'White'
          @input.text = ''
        else
          @player2 = Player.new(
            Window: self,
            Name: @input.text,
            Color: 'White'
          )
          @current_player = 'White'

          @settings[:Input] = false
          self.text_input = nil
          @input.text = ''
          @prompts[:Center].text = ''

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
    # TODO: Add drawing methods
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
    # TODO: Create a gui state for the game being played
    @current_player = 'Black'
    @prompts[:Left].text = "#{@player1.name}: #{@player1.color}"
    @prompts[:Right].text = "#{@player2.name}: #{@player2.color}"
    @prompts[:Center].text = @current_player
  end

  def info_state
    # TODO: Create a gui state for getting players names
    @current_player = 'Black'
    @prompts[:Left].text = ''
    @prompts[:Right].text = ''
    @settings[:Input] = true
    self.text_input = @input
  end

  def end_game_state
    @score = {
      Black: 13,
      White: 12}
    @winner = 'Black'

    @prompts[:Left].text = 'Press R to reset game'
    @prompts[:Right].text = 'Press C to close game'
    @prompts[:Center].text = "Black: #{@score[:Black]} White: #{@score[:White]}\nWinner: #{@winner}"

  end

  def draw_board
    for x in (0..7)
      for y in (0..7)
        draw_space(x, y, @board[x][y])
      end
    end
  end

  def draw_space(x, y, space)
    @images[space].draw(x * 50, (1 + y) * 50, 0)
  end
end

win = Window.new
win.show
