class Eroto < ActiveRecord::Base
  require 'open-uri'

  def self.crawl_new_article
    Eroto.delete_all
    targets = ['http://www.ero-to.com/movies/parody',
               'http://www.ero-to.com/movies/fantasy',
               'http://www.ero-to.com/movies/variety',
               'http://www.ero-to.com/cultures']
    targets.each do |target|
      page = Nokogiri::HTML(open(target))
      link = page.xpath('/html/body/div')[0].xpath('article')[0].xpath('ul/li')[0].xpath('a').first["href"]
      d_url = 'http://www.ero-to.com' + link
      d_page = Nokogiri::HTML(open(d_url))
      title = d_page.xpath('/html/body/div')[0].xpath('article')[0].xpath('section/h3').text.split('【')[0]
      content = d_page.xpath('/html/body/div')[0].xpath('article')[0].xpath('section/div')[1].text[0..200]
      thumbnail = page.xpath('/html/body/div')[0].xpath('article')[0].xpath('ul/li')[0].xpath('a/div/div')[0].xpath('img').first['src']
      e = Eroto.new(title: title, url: d_url, content: content, thumbnail: thumbnail)
      e.save
    end
    targets = ['http://www.ero-to.com/columns',
               'http://www.ero-to.com/actresses']
    targets.each do |target|
      page = Nokogiri::HTML(open(target))
      link = page.xpath('/html/body/div')[0].xpath('article')[0].xpath('ul/li')[0].xpath('a').first["href"]
      d_url = 'http://www.ero-to.com' + link
      d_page = Nokogiri::HTML(open(d_url))
      title = d_page.xpath('/html/body/div')[0].xpath('article')[0].xpath('section/h3').text.split('【')[0]
      content = d_page.xpath('/html/body/div')[0].xpath('article')[0].xpath('section/div')[0].text[0..200]
      thumbnail = page.xpath('/html/body/div')[0].xpath('article')[0].xpath('ul/li')[0].xpath('a/div/div')[0].xpath('img').first['src']
      e = Eroto.new(title: title, url: d_url, content: content, thumbnail: thumbnail)
      e.save
    end
  end
end
