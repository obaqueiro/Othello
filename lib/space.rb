require 'gosu'

# Space store contents of a space in the grid
class Space
  attr_accessor :window, :image
  attr_reader :state

  def initialize(window)
    @window = window
    @images = { White: new_image(File.expand_path('images/White_Circle.png')),
                Black: new_image(File.expand_path('images/Black_Circle.png')),
                Empty: new_image(File.expand_path('images/Empty_Space.png')) }
    @state = :Empty
    @image = @images[@state]
  end

  def new_image(filename)
    Gosu::Image.new(@window, filename, false)
  end

  def state=(state)
    @state = state
    @image = @images[state]
  end

  def draw_space(x, y)
    @image.draw(x * 50, (1 + y) * 50, 0)
  end
end
