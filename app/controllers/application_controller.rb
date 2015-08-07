class ApplicationController < ActionController::Base
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

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def set_new_user
    @user = User.new unless current_user
  end

  def user_id
    current_user ? current_user.id : session[:temp_id]
  end

  def toast(type, text)
    flash[:toastr] = { type => text }
  end

  def flash_clear
    flash[:toastr] = nil
  end

  # 現在のURLを保存しておく
  def save_current_url
    session[:request_from] = request.original_url
  end

  def previous_page
    session[:request_from] || root_path
  end

  def window_size
    current_user ? current_user.size : session[:size]
  end
end
