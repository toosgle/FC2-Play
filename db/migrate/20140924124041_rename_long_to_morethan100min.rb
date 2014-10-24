class RenameLongToMorethan100min < ActiveRecord::Migration
  def change
    remove_column :videos, :long
    add_column :videos, :morethan100min, :boolean
  end
end
