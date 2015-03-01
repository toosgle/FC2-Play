class AddBookmarkIndexToVideos < ActiveRecord::Migration
  def change
    add_index :videos, :bookmarks
  end
end
