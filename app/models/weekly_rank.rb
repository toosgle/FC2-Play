class WeeklyRank < ActiveRecord::Base
  belongs_to :video

  #FC*FC Playの週間ランキング
  def self.update
    WeeklyRank.delete_all
    Video.hot.weekly.each do |video|
      record = WeeklyRank.new(video_id: video.id)
      record.save
    end
  end

  def self.create_dummy
    WeeklyRank.delete_all
    50.times do
      record = WeeklyRank.new(video_id: 266086)
      record.save
    end
    MonthlyRank.create_dummy if MonthlyRank.all.size != 50
  end

end
