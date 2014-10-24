class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.string :kind
      t.date :day
      t.integer :value

      t.timestamps
    end
  end
end
