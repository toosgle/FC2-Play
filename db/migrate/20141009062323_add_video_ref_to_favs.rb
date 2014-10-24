class AddVideoRefToFavs < ActiveRecord::Migration
  def change
    add_reference :favs, :video, index: true
  end
end
