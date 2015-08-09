class Record < ActiveRecord::Base
  scope :of, ->(type, day) {
    where('kind LIKE ?', type)
      .where(day: day)
      .first
  }

  class << self
    module Constants
      REPORT_LIST = %w( total_play_his total_play_his_a total_favs total_users
                        total_reg_users total_videos total_updated_videos )
    end
    include Constants

    def create_all_his
      Record.delete_all
      # 2014-10-08 から7日に1回
      weeks_to_calc.times do |i|
        day = (start_day + (i * 7))
        create_a_record_of(day)
      end
    end

    def create_yesterday_his
      # 2014-10-08から7の倍数日経っていた場合
      create_a_record_of(Date.today) if days_to_calc % 7 == 0
    end

    def start_day
      Date.new(2014, 10, 8)
    end

    def days_to_calc
      (Date.today - start_day).to_i
    end

    def weeks_to_calc
      # 計算すべき日数から計算すべき週数を計算する
      (days_to_calc - (days_to_calc % 7)) / 7 + 1
    end

    def create_a_record_of(day)
      REPORT_LIST.each do |kind|
        Record.create(day: day,
                      kind: kind,
                      value: eval(kind + '_value(day)'))
      end
    end

    # 総再生回数(一般)
    def total_play_his_value(day)
      History.normal.joins(:video).before(day).count
    end

    # 総再生回数(アダルト)
    def total_play_his_a_value(day)
      History.adult.joins(:video).before(day).count
    end

    # お気に入り総数
    def total_favs_value(day)
      Fav.where("created_at < '#{day}'").count
    end

    # 登録ユーザ数総数
    def total_reg_users_value(day)
      User.where("created_at < '#{day}'").count
    end

    # ユーザ数総数
    def total_users_value(day)
      History.where("created_at < '#{day}'").group('user_id').length
    end

    # 動画総数
    def total_videos_value(day)
      Video.where("created_at < '#{day}'").count
    end

    # 動画情報更新総数
    def total_updated_videos_value(day)
      week_ago = day - 7
      Video.where('created_at <> updated_at')
        .where("created_at >= '#{week_ago}'")
        .where("created_at < '#{day}'").count
    end

    def create_reports
      result = initialize_report
      result[:weeks] = weeks_to_calc
      weeks_to_calc.times do |i|
        day = start_day + i * 7
        REPORT_LIST.each do |kind|
          result[kind.to_sym] << Record.of(kind, day).value
        end
      end
      result
    end

    def initialize_report
      REPORT_LIST.each_with_object({}) do |kind, hash|
        hash[kind.to_sym] = []
      end
    end
  end
end
