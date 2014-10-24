class AddImageUrlToMonthlyRankA < ActiveRecord::Migration
  def change
    add_column :monthly_rank_as, :image_url, :string
  end
end
