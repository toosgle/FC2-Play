class RenameFavsOfVideos < ActiveRecord::Migration
  def change
    remove_column :videos, :favs
    add_column :videos, :bookmarks, :integer
  end
end
