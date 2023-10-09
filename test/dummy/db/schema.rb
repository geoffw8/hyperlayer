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

ActiveRecord::Schema[7.1].define(version: 2023_10_09_185249) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.string "location"
    t.string "defined_class"
    t.string "event_type"
    t.string "method"
    t.text "return_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "path_id"
    t.integer "line_number"
    t.jsonb "spec"
    t.bigint "example_group_id", null: false
    t.jsonb "arguments"
    t.jsonb "variables"
    t.index ["example_group_id"], name: "index_events_on_example_group_id"
  end

  create_table "example_groups", force: :cascade do |t|
    t.string "location"
    t.string "description"
    t.bigint "spec_id", null: false
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["spec_id"], name: "index_example_groups_on_spec_id"
  end

  create_table "hyperlayer_events", force: :cascade do |t|
    t.string "location"
    t.string "defined_class"
    t.string "event_type"
    t.string "method"
    t.text "return_value"
    t.integer "path_id"
    t.integer "line_number"
    t.jsonb "spec"
    t.integer "example_group_id"
    t.jsonb "arguments"
    t.jsonb "variables"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hyperlayer_example_groups", force: :cascade do |t|
    t.string "location"
    t.string "description"
    t.integer "spec_id"
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hyperlayer_paths", force: :cascade do |t|
    t.string "path"
    t.boolean "spec"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hyperlayer_runs", force: :cascade do |t|
    t.integer "process"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hyperlayer_specs", force: :cascade do |t|
    t.string "location"
    t.string "description"
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "run_id"
  end

  create_table "paths", force: :cascade do |t|
    t.string "path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "spec"
  end

  create_table "runs", force: :cascade do |t|
    t.integer "process"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "specs", force: :cascade do |t|
    t.string "location"
    t.string "description"
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "run_id", null: false
    t.index ["run_id"], name: "index_specs_on_run_id"
  end

  add_foreign_key "events", "example_groups"
  add_foreign_key "example_groups", "specs"
  add_foreign_key "specs", "runs"
end
