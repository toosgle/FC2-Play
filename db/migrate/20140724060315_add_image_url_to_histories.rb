class AddImageUrlToHistories < ActiveRecord::Migration
  def change
    add_column :histories, :image_url, :string
  end
end
