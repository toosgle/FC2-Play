module InitializeAction
  extend ActiveSupport::Concern

  def set_ranking
    @week = Video.weekly_rank
    @month = Video.monthly_rank
    @new_arrivals = Video.new_arrivals_list
  end

  def set_user_info
    if current_user
      @favs = current_user.fav_list
    else
      session[:temp_id] ||= make_tmp_user_id
      @user = User.new
    end
    @histories = Video.user_histories(user_id)
    @bug_report = BugReport.new
  end

  private

  def make_tmp_user_id
    loop do
      tmp_id = rand(8_999_999) + 1_000_000
      return tmp_id if History.find_by(user_id: tmp_id).blank?
    end
  end
end
