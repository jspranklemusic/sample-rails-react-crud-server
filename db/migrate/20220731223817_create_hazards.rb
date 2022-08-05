class CreateHazards < ActiveRecord::Migration[7.0]
  def change
    create_table :hazards do |t|
      t.references :task, null: false, foreign_key: true
      t.string :description

      t.timestamps
    end
  end
end
