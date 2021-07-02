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

ActiveRecord::Schema.define(version: 2021_07_01_205129) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "gages", force: :cascade do |t|
    t.text "name"
    t.string "ibcw_id"
    t.text "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "offset"
    t.index ["ibcw_id"], name: "index_gages_on_ibcw_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email", null: false
    t.string "encrypted_password", limit: 128, null: false
    t.string "confirmation_token", limit: 128
    t.string "remember_token", limit: 128, null: false
    t.index ["email"], name: "index_users_on_email"
    t.index ["remember_token"], name: "index_users_on_remember_token"
  end

  create_table "waterflows", force: :cascade do |t|
    t.datetime "captured_at"
    t.decimal "stage", precision: 7, scale: 3
    t.decimal "discharge", precision: 9, scale: 2
    t.bigint "gage_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "precipitation", precision: 9, scale: 2
    t.index ["captured_at"], name: "index_waterflows_on_captured_at"
    t.index ["gage_id", "captured_at"], name: "index_waterflows_on_gage_id_and_captured_at", unique: true
    t.index ["gage_id"], name: "index_waterflows_on_gage_id"
  end

end
