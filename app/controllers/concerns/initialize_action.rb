module InitializeAction
  extend ActiveSupport::Concern

  def set_new_fav
    @fav = Fav.new if current_user
  end
end
