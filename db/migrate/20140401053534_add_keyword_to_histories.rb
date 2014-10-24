class AddKeywordToHistories < ActiveRecord::Migration
  def change
    add_column :histories, :keyword, :string
  end
end
