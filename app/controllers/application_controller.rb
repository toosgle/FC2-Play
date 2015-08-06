class ApplicationController < ActionController::Base
  include WindowAction
  include InitializeAction
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  if Rails.env == 'production'
    rescue_from ActionController::RoutingError,\
                ActionController::UrlGenerationError,\
                ActiveRecord::RecordNotFound,
                with: :render_404
    rescue_from Exception, with: :render_500
  end

  def render_404(exception = nil)
    if exception
      logger.info "Rendering 404 with exception: #{exception.message}"
    end
    respond_to do |format|
      format.html do
        render template: 'errors/error_404',
               layout: 'layouts/application',
               status: 404
      end
    end
  end

  def render_500(exception = nil)
    if exception
      logger.info "Rendering 500 with exception: #{exception.message}"
    end
    respond_to do |format|
      format.html do
        render template: 'errors/error_500',
               layout: 'layouts/application',
               status: 500
      end
    end
  end

  private

  def set_fc2_info
    page = Nokogiri::HTML(open(@url))
    @title = page.css('meta[@itemprop="name"]').attr('content').value
    @duration = page.css('meta[@property="video:duration"]')
                .attr('content').value
    @title.include?('Removed') ? false : true
  rescue
    false
  end

  def set_basic_info
    if current_user
      @favs = current_user.fav_list
      his = current_user.history_list
    else
      session[:temp_id] ||= make_tmp_id
      @user = User.new
      his = History.list(session[:temp_id])
    end
    @week = get_weekly_rank
    @month = get_monthly_rank
    @histories = get_user_histories(his)
    @new_arrivals = get_new_arrivals
    set_request_from
  end

  def make_tmp_id
    while 1 do
      tmp_id = rand(8_999_999) + 1_000_000
      p tmp_id
      break if History.find_by(user_id: tmp_id).nil?
    end
    tmp_id
  end

  def get_weekly_rank
    m_ids = get_video_ids(MonthlyRank.all.limit(100))
    m_query = ActiveRecord::Base.send(:sanitize_sql_array,
                                      ['field(id ,?)', m_ids])
    Video.where(id: m_ids).order(m_query)
  end

  def get_monthly_rank
    w_ids = get_video_ids(WeeklyRank.all.limit(100))
    w_query = ActiveRecord::Base.send(:sanitize_sql_array,
                                      ['field(id ,?)', w_ids])
    Video.where(id: w_ids).order(w_query)
  end

  def get_user_histories(his)
    his_ids = get_video_ids(his)
    his_query = ActiveRecord::Base.send(:sanitize_sql_array,
                                        ['field(id ,?)', his_ids])
    Video.where(id: his_ids).order(his_query)
  end

  def get_new_arrivals
    videos = []
    rcmd_videos_size = NewArrival.order('recommend desc').limit(20).size - 1
    (0..rcmd_videos_size).to_a.sample(10).each do |i|
      videos << NewArrival.order('recommend desc')[i]
    end
    videos
  end

  def get_video_ids(records)
    ids = []
    records.each do |r|
      ids << r.video_id
    end
    ids
  end

  def set_request_from
    @request_from = session[:request_from] if session[:request_from]
    # 現在のURLを保存しておく
    session[:request_from] = request.original_url
  end

  def set_play_info
    set_basic_info
    set_window_size
    @adult = session[:adult]
    @bug_report = BugReport.new

    # 再生できない報告後のリンク先のため
    session[:referer_url] = request.env['HTTP_REFERER']
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def toast(type, text)
    flash[:toastr] = { type => text }
  end

  def flash_clear
    flash[:toastr] = nil
  end

  def previous_page
    session[:request_from] || root_path
  end
end
