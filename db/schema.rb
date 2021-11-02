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

ActiveRecord::Schema.define(version: 2021_11_02_205231) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "csp_violations", force: :cascade do |t|
    t.jsonb "data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "gages", force: :cascade do |t|
    t.text "name"
    t.string "ibcw_id"
    t.text "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "offset"
    t.bigint "last_waterflow_id"
    t.decimal "latitude", precision: 7, scale: 4
    t.decimal "longitude", precision: 7, scale: 4
    t.index ["ibcw_id"], name: "index_gages_on_ibcw_id", unique: true
    t.index ["url"], name: "index_gages_on_url", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email", null: false
    t.string "encrypted_password", limit: 128, null: false
    t.string "confirmation_token", limit: 128
    t.string "remember_token", limit: 128, null: false
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email"
    t.index ["remember_token"], name: "index_users_on_remember_token"
  end

  create_table "waterflows", force: :cascade do |t|
    t.datetime "captured_at"
    t.decimal "stage"
    t.decimal "discharge", precision: 9, scale: 2
    t.bigint "gage_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "precipitation", precision: 9, scale: 2
    t.index ["captured_at"], name: "index_waterflows_on_captured_at"
    t.index ["gage_id", "captured_at"], name: "index_waterflows_on_gage_id_and_captured_at", unique: true
    t.index ["gage_id"], name: "index_waterflows_on_gage_id"
  end

  create_function :add_last_waterflow_id_to_gage, sql_definition: <<-SQL
      CREATE OR REPLACE FUNCTION public.add_last_waterflow_id_to_gage()
       RETURNS trigger
       LANGUAGE plpgsql
      AS $function$
      DECLARE
        most_recent_waterflow record;
      BEGIN
        SELECT id, captured_at
        INTO most_recent_waterflow
        FROM waterflows
        WHERE gage_id = NEW.gage_id
        ORDER BY captured_at DESC
        LIMIT 1;

        IF FOUND THEN
          RAISE NOTICE 'found captured_at';
          IF NEW.captured_at > most_recent_waterflow.captured_at THEN
            RAISE NOTICE 'new is greater than last_captured_at';
            UPDATE gages
            SET last_waterflow_id = NEW.id
            WHERE id = NEW.gage_id;
            RAISE NOTICE 'UPATED IN GREATER THAN';
          ELSE
            RAISE NOTICE 'new is not greater than las_captured_at';
            UPDATE gages
            SET last_waterflow_id = most_recent_waterflow.id
            WHERE id = NEW.gage_id;
            RAISE NOTICE 'UPATED IN NO GREATER THAN';
          END IF;
        ELSE
          UPDATE gages
          SET last_waterflow_id = NEW.id
          WHERE id = NEW.gage_id;
          RAISE NOTICE 'UPDATED IN NOT FOUND';
        END IF;

        RETURN NEW;
      END;
      $function$
  SQL


  create_trigger :add_last_waterflow_id_to_gage, sql_definition: <<-SQL
      CREATE TRIGGER add_last_waterflow_id_to_gage AFTER INSERT ON public.waterflows FOR EACH ROW EXECUTE FUNCTION add_last_waterflow_id_to_gage()
  SQL
end
