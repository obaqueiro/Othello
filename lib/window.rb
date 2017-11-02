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
      Color: :Black
    )

    @player2 = Player.new(
      Window: self,
      Color: :White
    )

    @show = {
    }
  end


  def button_down(id)
    case id
    when Gosu::MsLeft
    # TODO: Add Try catch for game turn

    when Gosu::KbR
    # TODO: Add logic for restarting the game
    when Gosu::KbC
    # TODO: Add
    when Gosu::KbReturn
    end
  end

  def update
  end

  def draw
    # TODO: Add drawing methods
  end
end

win = Window.new()
win.show
