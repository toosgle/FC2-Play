class Fc2
  require 'open-uri'

  attr_reader :title
  attr_reader :duration
  attr_reader :available

  def initialize(url)
    page = Nokogiri::HTML(open(url))
    @title = page.css('meta[@itemprop="name"]').attr('content').value
    @duration = page.css('meta[@property="video:duration"]')
                .attr('content').value
    @available = @title.include?('Removed') ? false : true
  rescue
    @available = false
  end

  class << self
    module Constants
      # FC2からのスクレイピングのパス
      ADULT_SEARCH_URL = 'http://video.fc2.com/en/a/movie_search.php?perpage=50&page='
      NORMAL_SEARCH_URL = 'http://video.fc2.com/en/movie_search.php?perpage=50&page='
      VIDEO_PATH = '//div[@class="video_list_renew clearfix"]'
      TITLE_PATH = './div[@class="video_info_right"]/h3'
      DURATION_PATH = './div[@class="video_list_renew_thumb"]/span'
      URL_PATH = './div[@class="video_info_right"]/h3/a'
      IMAGE_URL_PATH = './div[@class="video_list_renew_thumb"]/div/a/img'
      VIEWS_PATH = './div[@class="video_info_right"]/ul/li'
      FAVS_PATH = './div[@class="video_info_right"]/ul/li'
      AUTHORITY_PATH = './div[@class="video_info_right"]/ul/li'
    end
    include Constants

    def scrape(kind, from, to)
      adult_flg = (kind == 'adult')
      url = adult_flg ? ADULT_SEARCH_URL : NORMAL_SEARCH_URL
      from.upto(to) do |i|
        begin
          create_50_records(Nokogiri::HTML(open(url + i.to_s)), adult_flg)
        rescue
          next
        end
      end
    end

    def create_50_records(page, adult_flg)
      50.times do |j|
        next unless video_exists_on_fc2?(page.xpath(VIDEO_PATH)[j], adult_flg)
        params = scrape_params(page.xpath(VIDEO_PATH)[j], adult_flg)

        video = Video.find_by_title(params[:title])
        if video.present?
          video.update(params)
        else
          Video.create(params)
        end
      end
    end

    def scrape_params(elm, adult_flg)
      params = {}
      params[:title] = elm.xpath(TITLE_PATH).first.content
      params[:duration] = elm.xpath(DURATION_PATH).first.content
      params[:url] = elm.xpath(URL_PATH).first['href']
      params[:image_url] = elm.xpath(IMAGE_URL_PATH).first['src']
      params[:views] = elm.xpath(VIEWS_PATH)[1].content.to_i
      params[:bookmarks] = elm.xpath(FAVS_PATH)[2].content.to_i
      params[:morethan100min] = (params[:duration].length == 6)
      params[:adult] = adult_flg
      params
    end

    def video_exists_on_fc2?(elm, adult_flg)
      min_favs = adult_flg ? 30 : 2
      (elm.xpath(FAVS_PATH)[2] &&
        elm.xpath(FAVS_PATH)[2].content.to_i >= min_favs &&
          elm.xpath(AUTHORITY_PATH)[0].content == 'All')
    end
  end
end
