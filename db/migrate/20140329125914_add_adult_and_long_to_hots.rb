class AddAdultAndLongToHots < ActiveRecord::Migration
  def change
    add_column :hots, :adult, :boolean
    add_column :hots, :long, :boolean
  end
end
