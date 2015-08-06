module WindowAction
  extend ActiveSupport::Concern

  def window_category(size)
    case size
    when 590
      '小'
    when 750
      '中'
    when 900
      '大'
    end
  end

  def set_window_size
    @height = window_height
    @width = window_width
  end

  def valid_window?(size)
    [590, 750, 900].include?(size)
  end

  private

  def window_height
    if current_user
      (current_user.size * 0.6125).round
    elsif session[:size]
      (session[:size] * 0.6125).round
    else
      446
    end
  end

  def window_width
    if current_user
      current_user.size
    elsif session[:size]
      session[:size]
    else
      728
    end
  end
end
