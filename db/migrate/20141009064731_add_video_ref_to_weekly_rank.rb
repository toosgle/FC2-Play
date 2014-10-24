class AddVideoRefToWeeklyRank < ActiveRecord::Migration
  def change
    add_reference :weekly_ranks, :video, index: true
  end
end
