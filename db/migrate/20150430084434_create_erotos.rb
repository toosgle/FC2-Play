class CreateErotos < ActiveRecord::Migration
  def change
    create_table :erotos do |t|
      t.string :title
      t.string :url
      t.string :thumbnail
      t.string :content

      t.timestamps null: false
    end
  end
end
