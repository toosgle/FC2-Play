class AddDurationToMonthlyRankAs < ActiveRecord::Migration
  def change
    add_column :monthly_rank_as, :duration, :integer
  end
end
