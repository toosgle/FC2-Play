class HomeController < ApplicationController
  require 'open-uri'
  http_basic_authenticate_with :name => 'admin', :password => 'fc2play', :only => [:admin]
  after_filter :flash_clear, only: [:search, :change_player_size]

  def index
    set_root_info
  end

  def coming_soon
    render layout: false
  end

  def test
    @user = User.new if !(current_user)
  end

  def log
    @user = User.new if !(current_user)
  end

  def play
    #if out_of_limit?
    #  redirect_to root_url
    #  return
    #end

    #if got_to_survey?
    #  @survey = Survey.new
    #  render :survey
    #  return
    #end

    if @video = Video.find_by_title(params[:title])
      @url = @video.url
      @shorten_url = @url.split("/").last
    else
      toast :error, "タイトルに何か問題があるようです"
      redirect_to root_url
      return
    end
    if !set_fc2_info
      # handle 404 error
      delete_video(@video.id)
      @video.destroy
      toast :error, "この動画はFC2で既に削除されているようです　FC*FC Playからも削除しました"
      redirect_to root_url
      return
    end
    set_play_info
    create_history
    session[:video_url] = @url
    render :index
  end


  def search
    get_search_conditions
    @results = Video.search(@keywords_array, @bookmarks, @duration)
    toast :warning, "検索結果が多すぎるため、一部のみ表示しています" if @results.size == 200

    create_search_history
    set_previous_search_condition
    @user = User.new if !(current_user)
  end


  def change_player_size
    @size = window_size(params[:size].to_i)
    if @size
      session[:size] = params[:size].to_i
      toast :success, "ウィンドウサイズを #{@size} に変更しました。"
    else
      toast :error, "サイズ変更に失敗しました。もう一度試してみてください"
    end
    set_player_size
  end

  def report
    video = Video.find_by_title(params[:title])
    if video.destroy
      toast :success, "報告を受け取りました。ご協力ありがとうございます!"
    else
      toast :error, "報告に失敗しました。もう一度試してみてください。"
    end
    delete_video(video.id)
    redirect_to session[:referer_url]
  end

  def admin
    @user = User.new if !(current_user)
    set_reports_result
  end

  private

  def delete_video(vid)
    MonthlyRank.find_by_video_id(vid).delete if MonthlyRank.find_by_video_id(vid)
    WeeklyRank.find_by_video_id(vid).delete if WeeklyRank.find_by_video_id(vid)
    NewArrival.find_by_video_id(vid).delete if NewArrival.find_by_video_id(vid) && NewArrival.all.size > 10
  end

  def out_of_limit?
    case cause_of_limit
    when "hourly"
      toast :error, "只今、サイト全体で視聴制限をしています　もうしばらくしてから再度アクセスしてみてください"
    when "personal"
      toast :error, "本日30回視聴したため制限を行っています　24時を過ぎてから再びお楽しみください"
    else
      add_play_count
      false
    end
  end

  def cause_of_limit
    hour_ago = DateTime.now - Rational(1, 24)
    if History.where("created_at > ?", hour_ago).size > 1000
      return "hourly"
    elsif session[:pcount] && session[:pcount] >= 30 && session[:today] == Date.today
      return "personal"
    end
  end

  def add_play_count
    if !session[:today] || session[:today] != Date.today
      session[:today] = Date.today
      session[:pcount] = 1
    else
      session[:pcount] += 1
    end
  end

  def go_to_survey?
    rand(200)==0
  end

  def create_history
    if current_user && (session[:video_url] != @url)
      History.create_record(current_user.id, session[:keyword_re], @video.id)
    elsif session[:video_url] != @url
      History.create_record(session[:temp_id], session[:keyword_re], @video.id)
    end
  end

  def get_search_conditions
    search_keyword = params[:keyword] || ""
    @keyword = (search_keyword.gsub(/(　)+/,"\s"))
    @keywords_array = @keyword.split("\s")
    @bookmarks = params[:bookmarks] || "no"
    @duration = params[:duration] || "no"
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
    start = Date::new(2014, 10, 8)
    @days = ((Date.today-start-1).to_i)#/7
    reports = Record.create_reports(@days)
    @users = reports[:users]
    @playall = reports[:playall]
    @playall_adult = reports[:playall_adult]
    @favs = reports[:favs]
    @videos = reports[:videos]
    @updated_videos = reports[:updated_videos]

    @playweek= History.weekly_info_for_analyzer
    @survey_result = Survey.info_for_analyzer
    @bugreports = BugReport.all
  end

end
