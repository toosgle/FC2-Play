class AddDurationToMonthlyRanks < ActiveRecord::Migration
  def change
    add_column :monthly_ranks, :duration, :integer
  end
end
