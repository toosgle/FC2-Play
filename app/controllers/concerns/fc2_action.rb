module Fc2Action
  extend ActiveSupport::Concern

  def get_video_from_fc2
    page = Nokogiri::HTML(open(@video.url))
    @title = page.css('meta[@itemprop="name"]').attr('content').value
    @duration = page.css('meta[@property="video:duration"]')
                .attr('content').value
    @title.include?('Removed') ? false : true
  rescue
    false
  end
end
