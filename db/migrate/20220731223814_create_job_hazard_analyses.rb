class CreateJobHazardAnalyses < ActiveRecord::Migration[7.0]
  def change
    create_table :job_hazard_analyses do |t|
      t.references :job, null: false, foreign_key: true
      t.string :title
      t.integer :date
      t.text :summary
      t.references :author, null: false, foreign_key: true

      t.timestamps
    end
  end
end
