class CreateMonthlyRanks < ActiveRecord::Migration
  def change
    create_table :monthly_ranks do |t|
      t.string :title
      t.string :url

      t.timestamps
    end
  end
end
