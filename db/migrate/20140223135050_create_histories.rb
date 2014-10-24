class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.references :user, index: true
      t.string :mov_url

      t.timestamps
    end
  end
end
