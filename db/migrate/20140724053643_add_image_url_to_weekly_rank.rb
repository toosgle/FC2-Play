class AddImageUrlToWeeklyRank < ActiveRecord::Migration
  def change
    add_column :weekly_ranks, :image_url, :string
  end
end
