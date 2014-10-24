class ChangeSearchHis < ActiveRecord::Migration
  def change
    remove_column :search_his, :favs_from
    remove_column :search_his, :favs_to
    remove_column :search_his, :dur_from
    remove_column :search_his, :dur_to
    add_column :search_his, :favs, :string
    add_column :search_his, :duration, :string
  end
end
