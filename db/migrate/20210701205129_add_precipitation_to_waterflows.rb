class AddPrecipitationToWaterflows < ActiveRecord::Migration[6.1]
  def change
    add_column :waterflows, :precipitation, :decimal, precision: 9, scale: 2
  end
end
