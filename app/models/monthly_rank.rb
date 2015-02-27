class MonthlyRank < ActiveRecord::Base
  belongs_to :video

  #FC*FC Playの月間ランキング
  def self.update
    MonthlyRank.delete_all
    hot_videos = []
    Video.hot.monthly.each do |video|
      hot_videos << MonthlyRank.new(video_id: video.id)
    end
    MonthlyRank.import hot_videos
  end

  def self.create_dummy
    MonthlyRank.delete_all
    videos = []
    50.times do
      videos << MonthlyRank.new(video_id: 266118)
    end
    MonthlyRank.import videos
    WeeklyRank.create_dummy if WeeklyRank.all.size != 50
  end
end
