class CreateTriggerAddLastWaterflowIdToGage < ActiveRecord::Migration[6.1]
  def change
    create_trigger :add_last_waterflow_id_to_gage, on: :waterflows
  end
end
