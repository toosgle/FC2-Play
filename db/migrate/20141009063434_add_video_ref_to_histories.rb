class AddVideoRefToHistories < ActiveRecord::Migration
  def change
    add_reference :histories, :video, index: true
  end
end
