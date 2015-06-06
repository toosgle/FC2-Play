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
    redirect_to session[:request_from]
  end

  def destroy
    session[:user_id] = nil
    toast :success, 'ログアウトしました'
    redirect_to session[:request_from]
  end
end
