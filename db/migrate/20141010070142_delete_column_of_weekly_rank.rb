class DeleteColumnOfWeeklyRank < ActiveRecord::Migration
  def change
    remove_column :weekly_ranks, :title
    remove_column :weekly_ranks, :url
    remove_column :weekly_ranks, :duration
    remove_column :weekly_ranks, :image_url
  end
end
