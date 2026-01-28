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
    t.string "cloudinary_id"
    t.datetime "created_at", null: false
    t.bigint "creator_id"
    t.text "description"
    t.integer "file_size"
    t.string "file_type"
    t.integer "height"
    t.string "media_type"
    t.string "tags", default: [], array: true
    t.string "title"
    t.datetime "updated_at", null: false
    t.datetime "upload_date"
    t.text "url"
    t.bigint "user_id"
    t.integer "width"
    t.index ["cloudinary_id"], name: "index_assets_on_cloudinary_id"
    t.index ["created_at"], name: "index_assets_on_created_at"
    t.index ["creator_id"], name: "index_assets_on_creator_id"
    t.index ["user_id", "url", "media_type"], name: "index_assets_unique_per_user_and_type", unique: true
    t.index ["user_id"], name: "index_assets_on_user_id"
  end

  create_table "audit_logs", force: :cascade do |t|
    t.string "action"
    t.text "changes"
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.integer "resource_id"
    t.string "resource_type"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["created_at"], name: "index_audit_logs_on_created_at"
    t.index ["resource_type", "resource_id"], name: "index_audit_logs_on_resource_type_and_resource_id"
    t.index ["user_id"], name: "index_audit_logs_on_user_id"
  end

  create_table "creators", force: :cascade do |t|
    t.integer "assets_count", default: 0
    t.string "avatar_url"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "email"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["email"], name: "index_creators_on_email", unique: true
    t.index ["name"], name: "index_creators_on_name"
    t.index ["user_id"], name: "index_creators_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "admin", default: false
    t.string "avatar"
    t.text "bio"
    t.datetime "created_at", null: false
    t.string "email"
    t.boolean "is_verified", default: false
    t.string "name"
    t.string "password_digest"
    t.string "previews", default: [], array: true
    t.string "role", default: "creator"
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "assets", "creators"
  add_foreign_key "assets", "users"
  add_foreign_key "audit_logs", "users"
  add_foreign_key "creators", "users"
end
