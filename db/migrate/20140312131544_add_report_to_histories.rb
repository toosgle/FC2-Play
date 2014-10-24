class AddReportToHistories < ActiveRecord::Migration
  def change
    add_column :histories, :report, :integer
  end
end
