class RenameHotsToVideos < ActiveRecord::Migration
  def change
    rename_table :hots, :videos
  end
end
