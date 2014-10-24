class CreateBugReports < ActiveRecord::Migration
  def change
    create_table :bug_reports do |t|
      t.string :content

      t.timestamps
    end
  end
end
