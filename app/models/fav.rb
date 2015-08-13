class Fav < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates_presence_of :video_id
  validates_presence_of :user_id

  scope :list, ->(uid) {
    where(user_id: uid)
      .order('created_at desc')
  }

  def exist?
    Fav.where(user_id: user_id).where(video_id: video_id).present?
  end

  def more_than_100?
    Fav.where(user_id: user_id).count >= 100
  end
end
