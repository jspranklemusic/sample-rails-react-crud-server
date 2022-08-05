# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_08_01_203927) do
  create_table "authors", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hazards", force: :cascade do |t|
    t.integer "task_id", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["task_id"], name: "index_hazards_on_task_id"
  end

  create_table "job_hazard_analyses", force: :cascade do |t|
    t.integer "job_id", null: false
    t.string "title"
    t.integer "date"
    t.text "summary"
    t.integer "author_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_job_hazard_analyses_on_author_id"
    t.index ["job_id"], name: "index_job_hazard_analyses_on_job_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "safeguards", force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "task_id"
    t.index ["task_id"], name: "index_safeguards_on_task_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "job_hazard_analysis_id"
    t.index ["job_hazard_analysis_id"], name: "index_tasks_on_job_hazard_analysis_id"
  end

  add_foreign_key "hazards", "tasks"
  add_foreign_key "job_hazard_analyses", "authors"
  add_foreign_key "job_hazard_analyses", "jobs"
  add_foreign_key "tasks", "job_hazard_analyses"
end
