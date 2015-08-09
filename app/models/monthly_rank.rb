class MonthlyRank < ActiveRecord::Base
  belongs_to :video

  class << self
    # FC*FC Playの総合ランキング
    def update
      point = {}
      # 過去1ヶ月に再生された動画は1回につき1ポイント
      month_ago = DateTime.now - 30
      last_month_his = History.where("created_at > '#{month_ago}'")
                       .group('video_id')
                       .order('count(*) desc').limit(500)
                       .select('video_id, count(*) as count')
      last_month_his.each do |his|
        point[his.video_id] = his.count
      end
      # 過去1週間に再生された動画は1回につき8ポイント
      week_ago = DateTime.now - 7
      last_week_his = History.where("created_at > '#{week_ago}'")
                      .group('video_id')
                      .order('count(*) desc')
                      .limit(500)
                      .select('video_id, count(*) as count')
      last_week_his.each do |his|
        if point[his.video_id].blank?
          point[his.video_id] = his.count * 8
        else
          point[his.video_id] += his.count * 4
        end
      end
      # 過去3ヶ月にお気に入りされた動画は1つにつき100ポイント
      three_month_ago = DateTime.now - 90
      Fav.where("created_at > '#{three_month_ago}'").each do |fav|
        if point[fav.video_id].blank?
          point[fav.video_id] = 100
        else
          point[fav.video_id] += 100
        end
      end
      point = point.sort { |(_, v1), (_, v2)| v2 <=> v1 }

      MonthlyRank.delete_all
      hot_videos = []
      point.each do |pv|
        if hot_videos.size >= 300
          break
        elsif Video.where(id: pv[0]).present?
          hot_videos << MonthlyRank.new(video_id: pv[0])
        end
      end
      MonthlyRank.import hot_videos
    end

    def create_dummy
      MonthlyRank.delete_all
      videos = Video.all.limit(500).each_with_object([]) do |v, arr|
        arr << MonthlyRank.new(video_id: v.id)
      end
      MonthlyRank.import videos
      WeeklyRank.create_dummy if WeeklyRank.all.size != 500
    end
  end
end
