class CreateNewArrivals < ActiveRecord::Migration
  def change
    create_table :new_arrivals do |t|
      t.references :video, index: true
      t.string :title
      t.string :image_url
      t.string :duration
      t.integer :recommend

      t.timestamps
    end
  end
end
