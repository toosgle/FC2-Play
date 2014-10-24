class AddImageUrlToWeeklyRankA < ActiveRecord::Migration
  def change
    add_column :weekly_rank_as, :image_url, :string
  end
end
