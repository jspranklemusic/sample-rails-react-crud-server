class TaskToJha < ActiveRecord::Migration[7.0]
  def change
    remove_column :tasks, :jha_id
    add_reference :tasks, :job_hazard_analysis, foreign_key: {job_hazard_analyses: :id} 
  end
end
