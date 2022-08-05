class ChangeSafeguardForeignKeyToTask < ActiveRecord::Migration[7.0]
  def change
    change_table :safeguards do |t|
      t.remove_references :hazard
      t.references :task
    end
  end
end
