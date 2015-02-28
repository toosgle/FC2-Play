class Record < ActiveRecord::Base

  scope :of, ->(type, day) {
    where("kind LIKE ?", type) \
   .where(day: day) \
   .first
  }

  def self.create_all_his
    Record.delete_all
    start = Date.new(2014, 10, 8)
    days = (Date.today-start+1).to_i
    days.times do |i|
      day = (start+i).strftime('%Y-%m-%d')
      create_a_record_of(day)
    end
  end

  def self.create_yesterday_his
    create_a_record_of(Date.today)
  end

  def self.create_a_record_of(day)
    #総再生回数(一般)
    record = Record.new(day: day)
    record.kind = "total_play_his"
    record.value = History.normal.play_count(day)
    record.save
    #総再生回数(アダルト)
    record = Record.new(day: day)
    record.kind = "total_play_his_a"
    record.value = History.adult.play_count(day)
    record.save
    #お気に入り総数
    record = Record.new(day: day)
    record.kind = "total_fav"
    record.value = Fav.where("created_at < '#{day}'").size
    record.save
    #ユーザ数総数
    record = Record.new(day: day)
    record.kind = "total_user"
    record.value = User.where("created_at < '#{day}'").size
    record.save
    #動画総数
    record = Record.new(day: day)
    record.kind = "total_video"
    record.value = Video.where("created_at < '#{day}'").size
    record.save
    #動画情報更新総数
    record = Record.new(day: day)
    record.kind = "total_updated_video"
    record.value = Video.where("created_at <> updated_at").where("created_at < '#{day}'").size
    record.save
  end

  def self.create_reports(days)
    result = {}
    videos, updated_videos, users, his, adult_his, favs = [],[],[],[],[],[]
    days.times do |i|
      day = Date.today+(i-days)
      videos[i] = Record.of("total_video", day).value
      updated_videos[i] = Record.of("total_updated_video", day).value
      users[i] = Record.of("total_user", day).value
      his[i] = Record.of("total_play_his", day).value
      adult_his[i] = Record.of("total_play_his_a", day).value
      favs[i] = Record.of("total_fav", day).value
    end
    result[:videos] = videos
    result[:updated_videos] = updated_videos
    result[:users] = users
    result[:playall] = his
    result[:playall_adult] = adult_his
    result[:favs] = favs
    result
  end

end
