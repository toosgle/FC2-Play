class SessionsController < ApplicationController
  def new
  end

  #ログインの認証
  def create
    user = User.find_by_name(params[:name])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      toast :success, "ログインしました"
    else
      toast :error ,"IDかパスワードが間違っています"
    end
    redirect_to root_url
  end

  #ログアウト処理
  def destroy
    session[:user_id] = nil
    toast :success ,"ログアウトしました"
    redirect_to root_url
  end
end
