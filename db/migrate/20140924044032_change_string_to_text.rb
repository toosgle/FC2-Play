class ChangeStringToText < ActiveRecord::Migration
  def change
    remove_column :histories, :keyword
    add_column :histories, :keyword, :text

    remove_column :search_his, :keyword
    add_column :search_his, :keyword, :text
  end
end
