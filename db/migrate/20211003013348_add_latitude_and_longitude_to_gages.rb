class AddLatitudeAndLongitudeToGages < ActiveRecord::Migration[6.1]
  def change
    add_column :gages, :latitude, :decimal, precision: 7, scale: 4
    add_column :gages, :longitude, :decimal, precision: 7, scale: 4
  end
end
