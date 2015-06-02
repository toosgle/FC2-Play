class FavsController < ApplicationController
  require 'open-uri'

  before_action :set_fav, only: [:update, :destroy]
  after_filter :flash_clear

  def update
    if @fav.user_id == current_user.id && @fav.update(fav_params)
      toast :success, 'コメントを更新しました'
    else
      toast :error, '更新に失敗しました。もう一度試してみてください。'
    end
    @favs = current_user.fav_list
  end

  def create
    @fav = Fav.new(user_id: current_user.id,
                   video_id: fav_params[:video_id],
                   comment: fav_params[:comment])
    if @fav.exist?
      toast :warning, 'この動画はすでに登録されています'
    elsif @fav.cannot_create?
      toast :warning, 'これ以上お気に入りに追加できません。(最大100件)'
    elsif @fav.save
      toast :success, 'お気に入りに追加しました'
    else
      toast :error, '登録に失敗しました。もう一度試してみてください。'
    end
    @favs = current_user.fav_list
  end

  def destroy
    if @fav.user_id == current_user.id && @fav.destroy
      toast :success, 'お気に入りを削除しました'
    else
      toast :error, '削除に失敗しました。もう一度試してみてください。'
    end
    @favs = current_user.fav_list
  end

  private

  def set_fav
    @fav = Fav.find(params[:id])
  end

  # Never trust parameters from the scary internet.
  def fav_params
    params.require(:fav).permit(:comment, :video_id)
  end
end
