class NewArrival < ActiveRecord::Base
  belongs_to :video

  #2日に1回のfc2からのスクレイピングが終わるとこれが実行される
  def self.update
    new_arrivals = []
    Video.new_arrivals.each do |video|
      recommend = 1
      bpv = video.bookmarks*10000/video.views
      case bpv
      when 150..1000
        recommend += 3
      when 125..150-1
        recommend += 2
      when 100..125-1
        recommend += 1
      end
      recommend += 1 if video.views >= 10000
      new_arrivals << NewArrival.new(video_id: video.id,
                                   image_url: video.image_url,
                                   title: video.title,
                                   duration: video.duration,
                                   recommend: recommend)
    end
    NewArrival.delete_all
    NewArrival.import new_arrivals
  end
end
