class AddDurationToWeeklyRankAs < ActiveRecord::Migration
  def change
    add_column :weekly_rank_as, :duration, :integer
  end
end
