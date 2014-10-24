class CreateSearchHis < ActiveRecord::Migration
  def change
    create_table :search_his do |t|
      t.string :keyword
      t.integer :favs_from
      t.integer :favs_to
      t.string :dur_from
      t.string :dur_to

      t.timestamps
    end
  end
end
