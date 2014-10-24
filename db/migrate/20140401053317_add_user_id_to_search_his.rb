class AddUserIdToSearchHis < ActiveRecord::Migration
  def change
    add_column :search_his, :user_id, :integer
  end
end
