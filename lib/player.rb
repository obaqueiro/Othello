require 'gosu'
class Player
  attr_accessor :name, :color, :tag

  def initialize(args)
    @args = args
    @color = @args[:Color]
    @window = @args[:Window]
    @name = @args[:Name]
  end

  def set_player_name(text)
    @name = text
    @tag = Gosu::Image.from_text(@window, "#{@name} :#{@color}", 'Times New Roman', 20)
  end

  def draw_tag(cor)
    @x = cor[:x]
    @y = cor[:y]
    @z = cor[:z]
    @tag.draw(@x,
              @y,
              @z)
  end
end
