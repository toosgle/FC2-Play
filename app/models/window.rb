class Window
  attr_accessor :size
  attr_accessor :height
  attr_accessor :width

  module Constants
    module WindowSize
      SMALL = 590
      MIDDLE = 750
      LARGE = 900
    end
  end
  include Constants

  def initialize(size)
    @size = size.present? ? size.to_i : WindowSize::MIDDLE
    @height = (@size * 0.6125).round
    @width = @size
  end

  def valid?
    [WindowSize::SMALL, WindowSize::MIDDLE, WindowSize::LARGE].include?(@width)
  end

  def category
    list = {
      WindowSize::SMALL => '小',
      WindowSize::MIDDLE => '中',
      WindowSize::LARGE => '大' }
    list[@width]
  end
end
