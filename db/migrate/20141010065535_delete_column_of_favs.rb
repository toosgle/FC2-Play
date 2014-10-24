class DeleteColumnOfFavs < ActiveRecord::Migration
  def change
    remove_column :favs, :mov_url
    remove_column :favs, :title
    remove_column :favs, :image_url
    remove_column :favs, :report
    remove_column :favs, :duration
  end
end
