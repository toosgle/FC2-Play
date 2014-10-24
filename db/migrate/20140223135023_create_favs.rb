class CreateFavs < ActiveRecord::Migration
  def change
    create_table :favs do |t|
      t.references :user, index: true
      t.string :mov_url
      t.string :comment

      t.timestamps
    end
  end
end
