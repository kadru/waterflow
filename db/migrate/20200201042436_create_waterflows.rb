class CreateWaterflows < ActiveRecord::Migration[6.0]
  def change
    create_table :waterflows do |t|
      t.datetime :captured_at
      t.decimal :stage, precision: 7, scale: 3
      t.decimal :discharge, precision: 9, scale: 2
      t.belongs_to :river
      t.timestamps
    end

    add_index :waterflows, %i[river_id captured_at], unique: true
  end
end
