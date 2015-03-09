class MonthlyRank < ActiveRecord::Base
  belongs_to :video

  #FC*FC Playの総合ランキング
  def self.update
    point = {}
    # 過去1ヶ月に再生された動画は1回につき1ポイント
    month_ago = DateTime.now-30
    History.where("created_at > '#{month_ago}'").group("video_id").order('count(*) desc').limit(500)
           .select('video_id, count(*) as count').each do |his|
      point[his.video_id] = his.count
    end
    # 過去1週間に再生された動画は1回につき8ポイント
    week_ago = DateTime.now-7
    History.where("created_at > '#{week_ago}'").group("video_id").order('count(*) desc').limit(500)
           .select('video_id, count(*) as count').each do |his|
      point[his.video_id].blank? ? point[his.video_id] = his.count*8 : point[his.video_id] += his.count*4
    end
    # 過去3ヶ月にお気に入りされた動画は1つにつき100ポイント
    three_month_ago = DateTime.now-90
    Fav.where("created_at > '#{three_month_ago}'").each do |fav|
      point[fav.video_id].blank? ? point[fav.video_id] = 100 : point[fav.video_id] += 100
    end
    point = point.sort {|(k1, v1), (k2, v2)| v2 <=> v1 }

    MonthlyRank.delete_all
    hot_videos = []
    500.times do |i|
      hot_videos << MonthlyRank.new(video_id: point[i][0])
    end
    MonthlyRank.import hot_videos
  end

  def self.create_dummy
    MonthlyRank.delete_all
    videos = []
    Video.all.limit(500).each do |v|
      videos << MonthlyRank.new(video_id: v.id)
    end
    MonthlyRank.import videos
    WeeklyRank.create_dummy if WeeklyRank.all.size != 500
  end
end
