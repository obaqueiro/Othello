require 'gosu'

class Space
  attr_accessor :window, :current_state, :image

  def initialize(window)
    @window = window
    @images = { White: new_image(File.expand_path('images/White_Circle.png')),
                Black: new_image(File.expand_path('images/Black_Circle.png')),
                Empty: new_image(File.expand_path('images/Empty_Space.png')) }
    @current_state = :Empty
    @image = @images[@current_state]
  end

  def new_image(filename)
    Gosu::Image.new(@window, filename, false)
  end

  def get_contents
    @current_state
  end

  def set_contents(state)
    @current_state = state
    @image = @images[state]
  end

  def draw_space(x, y)
    @image.draw(x * 50, (1 + y) * 50, 0)
  end
end
