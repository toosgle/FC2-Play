class AddVideoRefToMonthlyRank < ActiveRecord::Migration
  def change
    add_reference :monthly_ranks, :video, index: true
  end
end
