class CreateCspViolations < ActiveRecord::Migration[6.1]
  def change
    create_table :csp_violations do |t|
      t.jsonb :data
      t.timestamps
    end
  end
end
