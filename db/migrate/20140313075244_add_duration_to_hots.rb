class AddDurationToHots < ActiveRecord::Migration
  def change
    remove_column :hots, :duration
  end
end
