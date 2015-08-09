class History < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  scope :list, ->(uid) {
    joins(:video)
      .where(user_id: uid)
      .order('created_at DESC')
      .limit(100)
  }

  scope :before, ->(day) {
    where('histories.created_at < ?', day)
  }

  scope :between, ->(from, to) {
    where('created_at between ? and ?', from, to)
  }

  scope :adult, ->{
    where("videos.url LIKE '%/a/%'")
  }

  scope :normal, ->{
    where("videos.url NOT LIKE '%/a/%'")
  }

  class << self
    # FCFCPlayのランキング更新
    def rank_update
      WeeklyRank.update
      MonthlyRank.update
    end

    # ユーザ登録した時に、tmp_idでの履歴情報を新しいUserIdの番号に書き換える
    def rename_user_history(tmp_user_id, id)
      History.where(user_id: tmp_user_id).update_all(user_id: id)
    end

    # 管理者用(admin)
    def weekly_report
      result = []
      days = 21 - (7 - Date.today.wday)
      21.times do |i|
        day = Date.today + i - days
        result << ((i < days) ? History.between(day, day + 1).count : 0)
      end
      result
    end
  end
end
