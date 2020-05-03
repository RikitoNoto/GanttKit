# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_03_104536) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "holidays", force: :cascade do |t|
    t.integer "day", null: false
    t.bigint "user_option_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_option_id"], name: "index_holidays_on_user_option_id"
  end

  create_table "plans", force: :cascade do |t|
    t.float "quantity", null: false
    t.float "time", null: false
    t.date "start_date", null: false
    t.time "start_time", null: false
    t.bigint "user_id", null: false
    t.bigint "task_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["task_id"], name: "index_plans_on_task_id"
    t.index ["user_id"], name: "index_plans_on_user_id"
  end

  create_table "progresses", force: :cascade do |t|
    t.float "quantity", null: false
    t.float "time", null: false
    t.date "start_date", null: false
    t.time "start_time", null: false
    t.bigint "user_id", null: false
    t.bigint "task_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["task_id"], name: "index_progresses_on_task_id"
    t.index ["user_id"], name: "index_progresses_on_user_id"
  end

  create_table "task_names", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "task_params", force: :cascade do |t|
    t.integer "order", null: false
    t.float "param", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "task_name_id", null: false
    t.index ["task_name_id"], name: "index_task_params_on_task_name_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.float "quantity", null: false
    t.string "unit"
    t.float "time"
    t.date "start_date", null: false
    t.time "start_time", null: false
    t.date "end_date", null: false
    t.time "end_time", null: false
    t.bigint "work_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "task_name_id", null: false
    t.text "description"
    t.index ["task_name_id"], name: "index_tasks_on_task_name_id"
    t.index ["work_id"], name: "index_tasks_on_work_id"
  end

  create_table "user_options", force: :cascade do |t|
    t.time "start", default: "2000-01-01 09:00:00", null: false
    t.time "end", default: "2000-01-01 18:00:00", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_options_on_user_id"
  end

  create_table "user_tasks", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "task_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["task_id"], name: "index_user_tasks_on_task_id"
    t.index ["user_id"], name: "index_user_tasks_on_user_id"
  end

  create_table "user_works", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "work_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_works_on_user_id"
    t.index ["work_id"], name: "index_user_works_on_work_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "works", force: :cascade do |t|
    t.string "name", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.time "start_time", null: false
    t.time "end_time", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "display", default: true
    t.text "description"
  end

  add_foreign_key "holidays", "user_options"
  add_foreign_key "plans", "tasks"
  add_foreign_key "plans", "users"
  add_foreign_key "progresses", "tasks"
  add_foreign_key "progresses", "users"
  add_foreign_key "task_params", "task_names"
  add_foreign_key "tasks", "task_names"
  add_foreign_key "tasks", "works"
  add_foreign_key "user_options", "users"
  add_foreign_key "user_tasks", "tasks"
  add_foreign_key "user_tasks", "users"
  add_foreign_key "user_works", "users"
  add_foreign_key "user_works", "works"
end
