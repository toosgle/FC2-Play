class NewArrival < ActiveRecord::Base
  belongs_to :video

  class << self
    # 2日に1回のfc2からのスクレイピングが終わると実行される
    def update
      new_arrivals = new_arrival_videos.each_with_object([]) do |video, arr|
        arr << NewArrival.new(video_id: video.id,
                              image_url: video.image_url,
                              title: video.title,
                              duration: video.duration,
                              recommend: calc_recommend(video))
      end
      NewArrival.delete_all
      NewArrival.import new_arrivals
    end

    def new_arrival_videos
      four_days_ago = DateTime.now - 3
      Video.where { (bookmarks * 10_000 / views) > 100 }
        .where { views > 2000 }
        .where { created_at > four_days_ago }
    end

    def calc_recommend(video)
      recommend = (video.views >= 10_000) ? 2 : 1
      case video.bookmarks * 10_000 / video.views
      when 150..1000
        recommend += 3
      when 125..150 - 1
        recommend += 2
      when 100..125 - 1
        recommend += 1
      end
      recommend
    end
  end
end
