class CreateRivers < ActiveRecord::Migration[6.0]
  def change
    create_table :rivers do |t|
      t.text :name
      t.string :ibcw_id
      t.text :url
      t.timestamps
    end
    add_index :rivers, :ibcw_id, unique: true
  end
end
