class AddDurationToWeeklyRanks < ActiveRecord::Migration
  def change
    add_column :weekly_ranks, :duration, :integer
  end
end
