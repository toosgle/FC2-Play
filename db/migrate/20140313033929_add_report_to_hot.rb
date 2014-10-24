class AddReportToHot < ActiveRecord::Migration
  def change
    add_column :hots, :report, :integer
  end
end
