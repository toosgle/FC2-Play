class DeleteColumnOfMonthlyRank < ActiveRecord::Migration
  def change
    remove_column :monthly_ranks, :title
    remove_column :monthly_ranks, :url
    remove_column :monthly_ranks, :duration
    remove_column :monthly_ranks, :image_url
  end
end
