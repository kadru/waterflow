class CreateFunctionAddLastWaterflowIdToGage < ActiveRecord::Migration[6.1]
  def change
    create_function :add_last_waterflow_id_to_gage
  end
end
