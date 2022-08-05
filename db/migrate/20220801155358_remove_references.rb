class RemoveReferences < ActiveRecord::Migration[7.0]
  def change
    change_table :safeguards do |t|
      t.remove_references :hazard
      t.remove_references :tasks
      t.references :task
    end
  end
end
