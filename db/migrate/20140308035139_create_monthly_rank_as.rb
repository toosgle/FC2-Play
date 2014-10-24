class CreateMonthlyRankAs < ActiveRecord::Migration
  def change
    create_table :monthly_rank_as do |t|
      t.string :title
      t.string :url

      t.timestamps
    end
  end
end
