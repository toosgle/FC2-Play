class History < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  scope :list, ->(uid) {
    joins(:video) \
   .where(user_id: uid) \
   .order("created_at DESC") \
   .limit(100)
  }

  scope :play_count, ->(day) {
    joins(:video) \
   .where("histories.created_at < ?", day) \
   .size
  }

  scope :adult, ->{
    where("videos.url LIKE '%/a/%'")
  }

  scope :normal, ->{
    where("videos.url NOT LIKE '%/a/%'")
  }

  def self.create_record(uid, keyword, video_id)
    history = History.new(user_id: uid, keyword: keyword, video_id: video_id)
    history.save
  end

  #FCFCPlayののランキング更新
  def self.rank_update
    WeeklyRank.update
    MonthlyRank.update
  end

  #管理者用(admin)
  def self.weekly_info_for_analyzer
    result = []
    days = 20 - (6-Date.today.wday)
    days.times do |i|
      day = Date.today+i-days
      nextday = Date.today+i-days+1
      result[i] = History.where('created_at between ? and ?', day, nextday).size
    end
    days.upto(20) do |i|
      result[i] = 0
    end
    result
  end

end
