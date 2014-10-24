class DeleteReportFromVideos < ActiveRecord::Migration
  def change
    remove_column :videos, :report
  end
end
