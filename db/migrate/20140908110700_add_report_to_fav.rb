class AddReportToFav < ActiveRecord::Migration
  def change
    add_column :favs, :report, :boolean, default: false
  end
end
