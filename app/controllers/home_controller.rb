class HomeController < ApplicationController
  require 'open-uri'
  include Fc2Action
  include WindowAction

  # You can login admin page !!!
  http_basic_authenticate_with name:  'admin',
                               password: 'fc2play',
                               only: [:admin]
  after_filter :flash_clear, only: [:search, :change_player_size]

  def index
    set_user_info
    set_ranking
  end

  def coming_soon
    render layout: false
  end

  def log
    @user = User.new unless current_user
  end

  def play
    # if got_to_survey?
    #  @survey = Survey.new
    #  render :survey
    #  return
    # end

    @video = Video.find_by_title(params[:title])
    unless prepare_video
      redirect_to root_url
      return
    end

    set_ranking
    set_user_info
    set_player
    create_watch_history
    render :index
  end

  def search
    get_search_conditions
    @results = Video.search(@keywords_array, @bookmarks, @duration)
    toast :warning, '検索結果が多すぎるため、一部のみ表示しています' if @results.size == 200

    create_search_history
    set_previous_search_condition
    set_request_from
    @user = User.new unless current_user
  end

  def change_player_size
    size = params[:size].to_i
    if valid_window?(size)
      session[:size] = size
      toast :success, "ウィンドウサイズを #{window_category(size)} に変更しました。"
    else
      toast :error, 'サイズ変更に失敗しました。もう一度試してみてください'
    end
    set_window_size
  end

  def report
    video = Video.find_by_title(params[:title])
    if Video.delete_all_by_id(video.id)
      toast :success, '報告を受け取りました。ご協力ありがとうございます!'
    else
      toast :error, '報告に失敗しました。もう一度試してみてください。'
    end
    redirect_to previous_page
  end

  def admin
    @user = User.new unless current_user
    set_reports_result
  end

  private

  def prepare_video
    if @video.blank?
      toast :error, 'タイトルに何か問題があるようです'
      Video.delete_all_by_title(params[:title])
      return false
    elsif !get_video_from_fc2
      toast :error, 'この動画はFC2で既に削除されているようです　FC*FC Playからも削除しました'
      Video.delete_all_by_id(@video.id)
      return false
    end
    true
  end

  def create_watch_history
    if current_user && (session[:previous_video_url] != @video.url)
      History.create_record(current_user.id, session[:keyword_re], @video.id)
    elsif session[:previous_video_url] != @video.url
      History.create_record(session[:temp_id], session[:keyword_re], @video.id)
    end
    session[:previous_video_url] = @video.url
  end

  def get_search_conditions
    search_keyword = params[:keyword] || ''
    @keyword = (search_keyword.gsub(/(　)+/, "\s"))
    @keywords_array = @keyword.split("\s")
    @bookmarks = params[:bookmarks] || 'no'
    @duration = params[:duration] || 'no'
  end

  def set_previous_search_condition
    session[:keyword_pre] = @keyword
    session[:bookmarks_pre] = @bookmarks
    session[:duration_pre] = @duration
  end

  def create_search_history
    if current_user
      SearchHis.create_record(@keyword, @bookmarks, @duration, current_user.id)
    else
      SearchHis.create_record(@keyword, @bookmarks, @duration, session[:temp_id])
    end
  end

  def set_reports_result
    reports = Record.create_reports
    @weeks = reports[:weeks]
    @reg_users = reports[:reg_users]
    @users = reports[:users]
    @playall = reports[:playall]
    @playall_adult = reports[:playall_adult]
    @favs = reports[:favs]
    @videos = reports[:videos]
    @updated_videos = reports[:updated_videos]

    @playweek = History.weekly_info_for_analyzer
    @survey_result = Survey.info_for_analyzer
    @bugreports = BugReport.all
  end
end
