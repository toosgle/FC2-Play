class AddTitleIndexToVideos < ActiveRecord::Migration
  def change
    add_index :videos, :title
  end
end
