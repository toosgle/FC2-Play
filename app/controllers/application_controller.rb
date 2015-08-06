class ApplicationController < ActionController::Base
  include WindowAction
  include Fc2Action
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

  def set_request_from
    @request_from = session[:request_from] if session[:request_from]
    # 現在のURLを保存しておく
    session[:request_from] = request.original_url
  end

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
    set_request_from
  end

  def make_tmp_user_id
    loop do
      tmp_id = rand(8_999_999) + 1_000_000
      return tmp_id if History.find_by(user_id: tmp_id).blank?
    end
  end

  def user_id
    current_user ? current_user.id : session[:temp_id]
  end

  def set_player
    set_window_size
    @shorten_url = @video.url.split('/').last
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
