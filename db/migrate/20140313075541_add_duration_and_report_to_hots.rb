class AddDurationAndReportToHots < ActiveRecord::Migration
  def change
    add_column :hots, :duration, :string
    add_column :hots, :report, :integer
  end
end
