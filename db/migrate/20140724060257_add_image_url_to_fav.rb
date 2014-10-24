class AddImageUrlToFav < ActiveRecord::Migration
  def change
    add_column :favs, :image_url, :string
  end
end
