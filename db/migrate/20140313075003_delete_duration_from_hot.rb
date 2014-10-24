class DeleteDurationFromHot < ActiveRecord::Migration
  def change
    remove_column :hots, :report
  end
end
