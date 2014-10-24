class DropRankTables < ActiveRecord::Migration
  def change
    drop_table :weekly_rank_as
    drop_table :monthly_rank_as
  end
end
