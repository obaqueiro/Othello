require 'gosu'
require_relative 'player'
class Window < Gosu::Window

  def initialize
    @window_height = 450
    @window_width = 400
    super(@window_width, @window_height, false)
    self.caption = 'Othello'

    @player1 = Player.new(
      Window: self,
      Color: :Black,
      Name: 'jeff'
    )

    @player2 = Player.new(
      Window: self,
      Color: :White,
      Name: 'john'
    )

    @prompt = Gosu::Font.new(20)
    @prompts = {
      Left: '',
      Center: '',
      Right: ''
    }

    @player_names = {
      Player1: "#{@player1.name} :#{@player1.color}",
      Player2: "#{@player2.name} :#{@player2.color}"
    }

    @board = Array.new(8) { Array.new(8) { :Empty } }
    @images = { White: Gosu::Image.new(File.expand_path('images/White_Circle.png'), false),
                Black: Gosu::Image.new(File.expand_path('images/Black_Circle.png'), false),
                Empty: Gosu::Image.new(File.expand_path('images/Empty_Space.png'), false) }

    @input = Gosu::TextInput.new
    @settings = {
      input: false
    }
  end

  def button_down(id)
    case id
    when Gosu::MsLeft
    # TODO: Add Try catch for game turn

    when Gosu::KbR
      reset unless @settings[:input]
    when Gosu::KbC
      close unless @settings[:input]
    when Gosu::KbReturn
    end

  end

  def reset
    @prompts[:Left] = @player_names[:Player1]
    @prompts[:Right] = @player_names[:Player2]
  end

  def update
    # TODO: Does the update need any logic?
  end

  def draw
    # TODO: Add drawing methods
    draw_board
    @prompt.draw(@prompts[:Right], right_of_screen(@prompt.text_width(@prompts[:Right])), 0, 0)
    @prompt.draw(@prompts[:Left], 0, 0, 0)
    @prompt.draw(@prompts[:Center], middle_of_screen(@prompt.text_width(@prompts[:Center])), 0, 0)
  end

  def right_of_screen(length)
    @window_width - length
  end

  def middle_of_screen(length)
    (@window_width / 2) - (length / 2)
  end

  def draw_score
  end

  def draw_players
    draw_player(:Player1, 0)
    draw_player(:Player2, @window_width - @player_names[:Player2].width)
  end

  def draw_player(player, x)
    @player_names[player].draw(x, 0, 0)
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
