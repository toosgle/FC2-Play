class AddImageUrlToMonthlyRank < ActiveRecord::Migration
  def change
    add_column :monthly_ranks, :image_url, :string
  end
end
