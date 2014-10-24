class AddTitleToHistories < ActiveRecord::Migration
  def change
    add_column :histories, :title, :string
  end
end
