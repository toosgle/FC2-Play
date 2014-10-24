class DeleteColumnOfHistories < ActiveRecord::Migration
  def change
    remove_column :histories, :mov_url
    remove_column :histories, :title
    remove_column :histories, :duration
    remove_column :histories, :image_url
    remove_column :histories, :report
  end
end
