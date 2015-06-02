class UsersController < ApplicationController
  before_action :set_user, only: [:update, :destroy]
  after_filter :flash_clear, only: [:update]

  def create
    @user = User.new(user_params)
    @user.size = 750
    if !@user.unique?
      toast :error, 'そのID名は既に使われています'
    elsif user_params[:password] != user_params[:password_confirmation]
      toast :error, 'パスワードが異なっています'
    elsif @user.save
      toast :success, '登録しました'
    else
      toast :error, '登録に失敗しました。もう一度試してみてください'
    end
    redirect_to root_url
  end

  def destroy
    if @user.destroy
      session[:user_id] = nil
      toast :success, 'アカウントを削除しました'
    else
      toast :error, 'アカウントの削除に失敗しました。もう一度試してみてください'
    end
    redirect_to root_path
  end

  def update
    @size = window_size(user_size_params[:size].to_i)
    if @size && @user.update(user_size_params)
      toast :success, 'ウィンドウサイズを #{@size} に変更しました。'
    else
      toast :error, 'サイズ変更に失敗しました。もう一度試してみてください'
    end
    set_player_size
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name,
                                 :password,
                                 :password_confirmation,
                                 :password_digest)
  end

  def user_size_params
    params.require(:user).permit(:size)
  end
end
