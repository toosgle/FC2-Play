class MonthlyRank < ActiveRecord::Base
  belongs_to :video

  #FC*FC Playの月間ランキング
  def self.update
    MonthlyRank.delete_all
    Video.hot.monthly.each do |video|
      record = MonthlyRank.new(video_id: video.id)
      record.save
    end
  end

  def self.create_dummy
    MonthlyRank.delete_all
    50.times do
      record = MonthlyRank.new(video_id: 266118)
      record.save
    end
    WeeklyRank.create_dummy if WeeklyRank.all.size != 50
  end
end
