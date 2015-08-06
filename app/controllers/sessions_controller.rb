class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_name(params[:name])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      toast :success, 'ログインしました'
    else
      toast :error, 'IDかパスワードが間違っています'
    end
    redirect_to previous_page
  end

  def destroy
    session[:user_id] = nil
    toast :success, 'ログアウトしました'
    redirect_to previous_page
  end

  private

  def previous_page
    session[:request_from] || root_path
  end
end
