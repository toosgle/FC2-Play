class AddDurationToFavs < ActiveRecord::Migration
  def change
    add_column :favs, :duration, :integer
  end
end
