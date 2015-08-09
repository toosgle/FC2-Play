class WeeklyRank < ActiveRecord::Base
  belongs_to :video

  class << self
    # FC*FC Playのイクイクランキング

    def update
      videos_with_iku_point = sort_by_iku_per_play(iku_point_in_three_month)

      # 保存
      hot_videos = videos_with_iku_point.each_with_object([]) do |v, arr|
        if arr.size >= 300
          break
        elsif Video.where(id: v[0]).present?
          arr << WeeklyRank.new(video_id: v[0])
        end
      end
      WeeklyRank.delete_all
      WeeklyRank.import hot_videos
    end

    # 最近3ヶ月の履歴から、イッたであろう動画を探し出す
    def iku_point_in_three_month
      pre = three_month_his.first
      iku_flg = false
      three_month_his.each_with_object({}) do |his, point|
        if was_iku_video?(pre, his, iku_flg)
          point[pre.video_id] ||= 0 # 初期化 if needed
          point[pre.video_id] += 1
        end
        iku_flg = will_iku_video?(pre, his)
        pre = his
      end
    end

    # user_idが変わるか、前回の再生から3時間以上経つ
    def was_iku_video?(pre, his, iku_flg)
      (pre.user_id != his.user_id || \
        his.created_at - pre.created_at > 10_800) && iku_flg
    end

    def will_iku_video?(pre, his)
      pre.user_id == his.user_id && his.created_at - pre.created_at < 10_800
    end

    def three_month_his
      History.where("created_at > '#{DateTime.now - 90}'")
    end

    # イクのに使われた回数/再生された回数 を計算してソーティング
    def sort_by_iku_per_play(iku_point)
      iku_point.each do |v_id, t|
        if playtimes[v_id] <= 3
          iku_point[v_id] = 0
        else
          iku_point[v_id] = (t * 1.0) / playtimes[v_id]
        end
      end
      iku_point.sort { |(_, v1), (_, v2)| v2 <=> v1 }
    end

    def playtimes
      three_month_his
        .group('video_id')
        .select('video_id, count(*) as count')
        .each_with_object({}) { |his, hash| hash[his.video_id] = his.count }
    end

    def create_dummy
      WeeklyRank.delete_all
      videos = Video.all.limit(500).each_with_object([]) do |v, arr|
        arr << WeeklyRank.new(video_id: v.id)
      end
      WeeklyRank.import videos
      MonthlyRank.create_dummy if MonthlyRank.all.size != 500
    end
  end
end
