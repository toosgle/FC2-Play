class AddTitleToFavs < ActiveRecord::Migration
  def change
    add_column :favs, :title, :string
  end
end
