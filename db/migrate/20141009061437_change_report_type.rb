class ChangeReportType < ActiveRecord::Migration
  def change
    remove_column :videos, :report
    add_column :videos, :report, :boolean, default: false
    remove_column :histories, :report
    add_column :histories, :report, :boolean, default: false
  end
end
