class CreateHots < ActiveRecord::Migration
  def change
    create_table :hots do |t|
      t.string :title
      t.string :url
      t.integer :duration
      t.integer :views
      t.integer :favs

      t.timestamps
    end
  end
end
