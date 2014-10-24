class CreateWeeklyRanks < ActiveRecord::Migration
  def change
    create_table :weekly_ranks do |t|
      t.string :title
      t.string :url

      t.timestamps
    end
  end
end
