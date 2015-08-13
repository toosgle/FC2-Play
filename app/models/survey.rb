class Survey < ActiveRecord::Base
  validates_presence_of :result

  class << self
    # 管理者用(admin)
    def report
      result = []
      day = Date.today - 14
      1.upto(5) do |i|
        result[i] = Survey.where(result: i).where("created_at > '#{day}'").count
      end
      result
    end
  end
end
