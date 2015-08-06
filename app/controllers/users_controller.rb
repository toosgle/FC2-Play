class UsersController < ApplicationController
  include WindowAction

  before_action :set_user, only: [:update, :destroy]
  after_filter :flash_clear, only: [:update]

  def create
    @user = User.new(user_params)
    @user.size = 750
    if valid_user?
      if @user.save_and_rewrite_his(session[:user_id])
        toast :success, '登録しました'
      else
        toast :error, '登録に失敗しました。もう一度試してみてください'
      end
    end
    redirect_to previous_page
  end

  def destroy
    if @user.destroy
      session[:user_id] = nil
      toast :success, 'アカウントを削除しました'
    else
      toast :error, 'アカウントの削除に失敗しました。もう一度試してみてください'
    end
    redirect_to root_url
  end

  # Ajax for updating window size
  def update
    size = window_params[:size].to_i
    if valid_window?(size) && @user.update(window_params)
      toast :success, "ウィンドウサイズを #{window_category(size)} に変更しました。"
    else
      toast :error, 'サイズ変更に失敗しました。もう一度試してみてください'
    end
    set_window_size
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user)
      .permit(:name,
              :password,
              :password_confirmation,
              :password_digest)
  end

  def window_params
    params.require(:user).permit(:size)
  end

  def valid_user?
    if !@user.unique?
      toast :error, 'そのID名は既に使われています'
      false
    elsif user_params[:password] != user_params[:password_confirmation]
      toast :error, 'パスワードが異なっています'
      false
    else
      true
    end
  end
end
