class MonthlyRank < ActiveRecord::Base
  belongs_to :video

  class << self
    # FC*FC Playの総合ランキング
    def update
      hot_videos = []
      videos_order_by_point.each do |video_id|
        if hot_videos.size >= 300
          break
        elsif Video.where(id: video_id).present?
          hot_videos << MonthlyRank.new(video_id: video_id)
        end
      end
      MonthlyRank.delete_all
      MonthlyRank.import hot_videos
    end

    def videos_order_by_point
      point = calc_last_month_point
      point = calc_last_week_point(point)
      point = calc_therr_month_favs_point(point)

      # ポイントが高い順にソート
      point.sort { |(_, v1), (_, v2)| v2 <=> v1 }

      # video_idの配列を返す
      point.each_with_object([]) do |pt, video_ids|
        video_ids << pt[0]
      end
    end

    # 過去1ヶ月に再生された動画は1回につき1ポイント
    def calc_last_month_point
      last_month_his.each_with_object({}) do |his, point|
        point[his.video_id] = his.count
      end
    end

    def last_month_his
      History.where("created_at > '#{DateTime.now - 30}'")
        .group('video_id')
        .order('count(*) desc').limit(500)
        .select('video_id, count(*) as count')
    end

    # 過去1週間に再生された動画は1回につき8ポイント
    def calc_last_week_point(point)
      last_week_his.each do |his|
        point[his.video_id] ||= 0 # 初期化 if needed
        point[his.video_id] += his.count * 8
      end
      point
    end

    def last_week_his
      History.where("created_at > '#{DateTime.now - 7}'")
        .group('video_id')
        .order('count(*) desc')
        .limit(500)
        .select('video_id, count(*) as count')
    end

    # 過去3ヶ月にお気に入りされた動画は1つにつき100ポイント
    def calc_therr_month_favs_point(point)
      three_month_favs.each do |fav|
        if point[fav.video_id].blank?
          point[fav.video_id] = 100
        else
          point[fav.video_id] += 100
        end
      end
      point
    end

    def three_month_favs
      Fav.where("created_at > '#{DateTime.now - 90}'")
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
