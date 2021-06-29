class RenameRiversToGages < ActiveRecord::Migration[6.1]
  def change
    rename_table :rivers, :gages
    rename_column :waterflows, :river_id, :gage_id
  end
end
