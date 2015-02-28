class WeeklyRank < ActiveRecord::Base
  belongs_to :video

  #FC*FC Playの週間ランキング
  def self.update
    WeeklyRank.delete_all
    hot_videos = []
    Video.hot.weekly.each do |video|
      hot_videos << WeeklyRank.new(video_id: video.id)
    end
    WeeklyRank.import hot_videos
  end

  def self.create_dummy
    WeeklyRank.delete_all
    videos = []
    Video.all.limit(500).each do |v|
      videos << WeeklyRank.new(video_id: v.id)
    end
    WeeklyRank.import videos
    MonthlyRank.create_dummy if MonthlyRank.all.size != 500
  end

end
