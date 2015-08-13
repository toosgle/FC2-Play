class FavsController < ApplicationController
  before_action :set_fav, only: [:update, :destroy]
  before_action :set_user_fav_list
  after_filter :flash_clear

  def update
    if set_user_id && @fav.update(fav_params)
      toast :success, 'コメントを更新しました'
    else
      toast :error, '更新に失敗しました。もう一度試してみてください。'
    end
  end

  def create
    @fav = Fav.new(fav_params)
    @fav.user_id = current_user.id
    return unless valid_fav?
    if @fav.save
      toast :success, 'お気に入りに追加しました'
    else
      toast :error, '登録に失敗しました。もう一度試してみてください。'
    end
  end

  def destroy
    if set_user_id && @fav.destroy
      toast :success, 'お気に入りを削除しました'
    else
      toast :error, '削除に失敗しました。もう一度試してみてください。'
    end
  end

  private

  def set_fav
    @fav = Fav.find(params[:id])
  end

  # Never trust parameters from the scary internet.
  def fav_params
    params.require(:fav).permit(:comment, :video_id)
  end

  def set_user_id
    @fav.user_id == current_user.id
  end

  def set_user_fav_list
    @favs = current_user.fav_list
  end

  def valid_fav?
    if @fav.exist?
      toast :warning, 'この動画はすでに登録されています'
      false
    elsif @fav.more_than_100?
      toast :warning, 'これ以上お気に入りに追加できません。(最大100件)'
      false
    else
      true
    end
  end
end
