class AddLastWaterflowIdToGages < ActiveRecord::Migration[6.1]
  def change
    add_column :gages, :last_waterflow_id, :bigint
  end
end
