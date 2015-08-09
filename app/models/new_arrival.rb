class NewArrival < ActiveRecord::Base
  belongs_to :video

  # 2日に1回のfc2からのスクレイピングが終わると実行される
  def self.update
    new_arrivals = Video.new_arrivals.each_with_object([]) do |video, arr|
      arr << NewArrival.new(video_id: video.id,
                            image_url: video.image_url,
                            title: video.title,
                            duration: video.duration,
                            recommend: video.recommend)
    end
    NewArrival.delete_all
    NewArrival.import new_arrivals
  end
end
