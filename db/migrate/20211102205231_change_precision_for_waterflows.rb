class ChangePrecisionForWaterflows < ActiveRecord::Migration[6.1]
  def change
    change_column :waterflows, :stage, :decimal
  end
end
