class AddSizeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :size, :integer
  end
end
