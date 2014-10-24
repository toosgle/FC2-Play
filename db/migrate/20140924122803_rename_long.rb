class RenameLong < ActiveRecord::Migration
  def change
    remove_column :videos, :morethan100min
    add_column :videos, :long, :boolean
  end
end
