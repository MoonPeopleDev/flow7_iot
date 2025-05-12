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

ActiveRecord::Schema[7.2].define(version: 2025_04_14_215609) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "devices_hardware_items", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.bigint "hardware_model_id", null: false
    t.string "serial_number"
    t.datetime "last_online_at"
    t.string "firmware_version"
    t.integer "uptime", default: 0, null: false
    t.boolean "receive_data", default: true, null: false
    t.string "aes_key"
    t.string "aes_iv"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hardware_model_id"], name: "index_devices_hardware_items_on_hardware_model_id"
  end

  create_table "devices_hardware_models", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "devices_hardware_models_sensor_types", id: false, force: :cascade do |t|
    t.bigint "devices_hardware_model_id", null: false
    t.bigint "devices_sensor_type_id", null: false
    t.index ["devices_hardware_model_id", "devices_sensor_type_id"], name: "index_dhm_dst_on_model_and_type"
    t.index ["devices_sensor_type_id", "devices_hardware_model_id"], name: "index_dst_dhm_on_type_and_model"
  end

  create_table "devices_sensor_types", force: :cascade do |t|
    t.string "name"
    t.string "data_key_name"
    t.string "description"
    t.boolean "scalable", default: false, null: false
    t.integer "scalable_by", default: 0, null: false
    t.integer "general_data_method", default: 0, null: false
    t.integer "chart_type", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "devices_sensors", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.bigint "sensor_type_id", null: false
    t.bigint "hardware_item_id", null: false
    t.integer "threshold_active", default: 3, null: false
    t.integer "threshold_idle", default: 2, null: false
    t.integer "threshold_shutdown", default: 1, null: false
    t.string "value_factor"
    t.string "power_factor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hardware_item_id"], name: "index_devices_sensors_on_hardware_item_id"
    t.index ["sensor_type_id"], name: "index_devices_sensors_on_sensor_type_id"
  end

  add_foreign_key "devices_hardware_items", "devices_hardware_models", column: "hardware_model_id"
  add_foreign_key "devices_sensors", "devices_hardware_items", column: "hardware_item_id"
  add_foreign_key "devices_sensors", "devices_sensor_types", column: "sensor_type_id"
end
