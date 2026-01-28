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

ActiveRecord::Schema[8.1].define(version: 2026_01_28_095811) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "assets", force: :cascade do |t|
    t.string "author_avatar"
    t.string "author_name"
    t.datetime "created_at", null: false
    t.string "media_type"
    t.string "tags", default: [], array: true
    t.string "title"
    t.datetime "updated_at", null: false
    t.datetime "upload_date"
    t.text "url"
    t.bigint "user_id", null: false
    t.index ["user_id", "url", "media_type"], name: "index_assets_unique_per_user_and_type", unique: true
    t.index ["user_id"], name: "index_assets_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "avatar"
    t.text "bio"
    t.datetime "created_at", null: false
    t.boolean "is_verified", default: false
    t.string "name"
    t.string "password_digest"
    t.string "previews", default: [], array: true
    t.string "role", default: "creator"
    t.datetime "updated_at", null: false
    t.string "username"
  end

  add_foreign_key "assets", "users"
end
