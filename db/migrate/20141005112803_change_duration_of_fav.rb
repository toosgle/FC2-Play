class ChangeDurationOfFav < ActiveRecord::Migration
  def change
    remove_column :favs, :duration
    add_column :favs, :duration, :string
  end
end
