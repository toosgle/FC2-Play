class WeeklyRank < ActiveRecord::Base
  belongs_to :video

  # FC*FC Playのイクイクランキング
  def self.update
    # 最近3ヶ月の履歴から、イッたであろう動画を探し出す
    iku_video = {}
    three_month_ago = DateTime.now - 90
    first = History.where("created_at > '#{three_month_ago}'").first
    p_uid = first.user_id
    p_view = first.created_at
    p_vid = first.video_id
    add_flg = false
    History.where("created_at > '#{three_month_ago}'").each do |his|
      # user_idが変わるか、前回の再生から3時間以上経つ
      if (p_uid != his.user_id || his.created_at - p_view > 10_800) && add_flg
        iku_video[p_vid].blank? ? iku_video[p_vid] = 1 : iku_video[p_vid] += 1
        add_flg = false
      elsif p_uid == his.user_id && his.created_at - p_view < 10_800
        add_flg = true
      end
      p_uid = his.user_id
      p_view = his.created_at
      p_vid = his.video_id
    end

    # イクのに使われた回数/再生された回数 を計算してソーティング
    h = History.where("created_at > '#{three_month_ago}'")
        .group('video_id')
        .select('video_id, count(*) as count')
    playtimes = {}
    h.each do |his|
      playtimes[his.video_id] = his.count
    end
    iku_video.each do |v_id, t|
      if playtimes[v_id] <= 3
        iku_video[v_id] = 0
      else
        iku_video[v_id] = (t * 1.0) / playtimes[v_id]
      end
    end
    iku_video = iku_video.sort { |(_, v1), (_, v2)| v2 <=> v1 }

    # 保存
    WeeklyRank.delete_all
    hot_videos = []
    iku_video.each do |iv|
      if hot_videos.size >= 300
        break
      elsif Video.where(id: iv[0]).present?
        hot_videos << WeeklyRank.new(video_id: iv[0])
      end
    end
    WeeklyRank.import hot_videos
  end

  def self.create_dummy
    WeeklyRank.delete_all
    videos = Video.all.limit(500).each_with_object([]) do |v, arr|
      arr << WeeklyRank.new(video_id: v.id)
    end
    WeeklyRank.import videos
    MonthlyRank.create_dummy if MonthlyRank.all.size != 500
  end
end
