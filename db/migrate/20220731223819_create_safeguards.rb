class CreateSafeguards < ActiveRecord::Migration[7.0]
  def change
    create_table :safeguards do |t|
      t.references :hazard, null: false, foreign_key: true
      t.string :description

      t.timestamps
    end
  end
end
