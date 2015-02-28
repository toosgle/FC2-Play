class Fav < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates_presence_of :video_id
  validates_presence_of :user_id

  scope :list, ->(uid) {
    joins(:video) \
   .where(user_id: uid) \
   .order("created_at desc")
  }

  def exist?
    Fav.where(user_id: self.user_id).where(video_id: self.video_id).size >= 1
  end

  def cannot_create?
    Fav.where(user_id: self.user_id).size >= 100
  end

end
