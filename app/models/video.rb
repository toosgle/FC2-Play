class Video < ActiveRecord::Base
  require 'open-uri'
  acts_as_paranoid

  has_many :favs
  has_many :histories
  has_many :monthly_ranks
  has_many :weekly_ranks
  validates_presence_of :title
  validates_presence_of :url
  validates_presence_of :views
  validates_presence_of :duration
  validates_presence_of :image_url
  validates_presence_of :bookmarks
  validates_inclusion_of :adult, in: [true, false]
  validates_inclusion_of :morethan100min, in: [true, false]

  scope :new_arrivals, -> {
    four_days_ago = DateTime.now - 3
    where { bookmarks * 10_000 / views > 100 }
      .where { views > 2000 }
      .where { created_at > four_days_ago }
  }
  scope :title_is, ->(keywords) {
    sql = keywords.inject('') { |sql, words| sql += "(title LIKE '%#{words}%') AND " } + '(1=1'
    where(sql[1..sql.length])
  }
  scope :bookmarks_is, ->(condition) {
    case condition
    when 's'
      where(bookmarks: 30..500)
    when 'm'
      where(bookmarks: 500..2000)
    when 'l'
      where { bookmarks >= 2000 }
    end
  }
  scope :duration_is, ->(condition) {
    case condition
    when 's'
      where(duration: '00:00'..'10:00').where(morethan100min: 0)
    when 'm'
      where(duration: '10:00'..'30:00').where(morethan100min: 0)
    when 'l'
      where(duration: '30:00'..'60:00').where(morethan100min: 0)
    when 'xl'
      where("duration >= '60:00' or morethan100min = 1")
    end
  }
  scope :search, ->(keywords, bookmarks, duration) {
    title_is(keywords)
      .bookmarks_is(bookmarks)
      .duration_is(duration)
      .order('bookmarks DESC')
      .limit(200)
  }

  def self.check_available
    Video.all.each do |video|
      video.destroy unless video.available?
    end
  end

  def available?
    page = Nokogiri::HTML(open(url))
    title = page.css('meta[@itemprop="name"]').attr('content').value
    title.include?('Removed') ? false : true
  rescue
    false
  end

  def self.delete_unavailable
    Video.only_deleted.delete_all
  end

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

  # 毎日1→3000ページ(150000動画)を更新
  def self.daily_update
    start_scrape('update', 1, 3000, 1, 1500)
    # 新着オススメ動画の更新
    NewArrival.update
  end

  # 全部消して初期化する 750000を検索
  def self.set_init
    start_scrape('init', 1, 17_000, 1, 17_000)
  end

  def self.start_scrape(kinds, adult_from, adult_to, normal_from, normal_to)
    Video.delete_all if kinds == 'init'

    # アダルト
    adult_from.upto(adult_to) do |i|
      p i
      next unless page = Nokogiri::HTML(open(ADULT_SEARCH_URL + i.to_s))
      create_50_records(page, 'adult')
    end
    # 一般
    normal_from.upto(normal_to) do |i|
      p i
      next unless page = Nokogiri::HTML(open(NORMAL_SEARCH_URL+i.to_s))
      create_50_records(page, 'normal')
    end
  end

  def self.create_50_records(page, kinds)
    adult_flg = (kinds == 'adult')
    elms = page.xpath(VIDEO_PATH)
    50.times do |j|
      if video_exists_on_fc2?(elms[j], kinds)
        title = elms[j].xpath(TITLE_PATH).first.content
        duration = elms[j].xpath(DURATION_PATH).first.content
        url = elms[j].xpath(URL_PATH).first['href']
        image_url = elms[j].xpath(IMAGE_URL_PATH).first['src']
        views = elms[j].xpath(VIEWS_PATH)[1].content
        bookmarks = elms[j].xpath(FAVS_PATH)[2].content
        morethan100min = (duration.length == 6)
        # 保存
        video = Video.find_by_title(title)
        if video.present?
          video.views = views.to_i
          video.bookmarks = bookmarks.to_i
          video.touch
          video.save
        else
          video = Video.new(title: title,
                            url: url,
                            image_url: image_url,
                            duration: duration,
                            views: views.to_i,
                            bookmarks: bookmarks.to_i,
                            adult: adult_flg,
                            morethan100min: morethan100min)
          video.save
        end
      end
    end
  end

  def self.video_exists_on_fc2?(elm, type)
    if type == 'normal'
      (elm.xpath(FAVS_PATH)[2] &&
        elm.xpath(FAVS_PATH)[2].content.to_i >= 2 &&
          elm.xpath(AUTHORITY_PATH)[0].content == 'All')
    elsif type == 'adult'
      (elm.xpath(FAVS_PATH)[2] &&
        elm.xpath(FAVS_PATH)[2].content.to_i >= 30 &&
          elm.xpath(AUTHORITY_PATH)[0].content == 'All')
    end
  end
end
