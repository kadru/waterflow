class AddUniqueIndexOnUrlToGages < ActiveRecord::Migration[6.1]
  def change
    add_index(:gages, :url, unique: true)
  end
end
