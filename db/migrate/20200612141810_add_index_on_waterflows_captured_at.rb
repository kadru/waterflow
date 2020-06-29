class AddIndexOnWaterflowsCapturedAt < ActiveRecord::Migration[6.0]
  def change
    add_index :waterflows, :captured_at
  end
end
