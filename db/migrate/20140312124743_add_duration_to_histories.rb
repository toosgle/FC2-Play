class AddDurationToHistories < ActiveRecord::Migration
  def change
    add_column :histories, :duration, :integer
  end
end
