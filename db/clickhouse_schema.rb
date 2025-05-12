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

ActiveRecord::Schema[7.2].define(version: 2025_04_15_192200) do
  # TABLE: sensor_data_agg_10m
  # SQL: CREATE TABLE sensor_data_agg_10m ( `at` DateTime64(3, 'UTC'), `device_id` UInt32, `serial_number` String, `sensor_id` UInt32, `sensor_type_id` UInt16, `sum_value_state` AggregateFunction(sum, Int32), `max_value_state` AggregateFunction(max, Int32), `min_value_state` AggregateFunction(min, Int32), `avg_value_state` AggregateFunction(avg, Int32) ) ENGINE = SummingMergeTree PARTITION BY toYYYYMMDD(at) ORDER BY (device_id, serial_number, sensor_id, sensor_type_id, at) SETTINGS index_granularity = 8192
  create_table "sensor_data_agg_10m", id: false, options: "SummingMergeTree PARTITION BY toYYYYMMDD(at) ORDER BY (device_id, serial_number, sensor_id, sensor_type_id, at) SETTINGS index_granularity = 8192", force: :cascade do |t|
    t.datetime "at", precision: nil, null: false
    t.integer "device_id", null: false
    t.string "serial_number", null: false
    t.integer "sensor_id", null: false
    t.integer "sensor_type_id", limit: 2, null: false
    t.integer "sum_value_state", unsigned: false, null: false
    t.integer "max_value_state", unsigned: false, null: false
    t.integer "min_value_state", unsigned: false, null: false
    t.integer "avg_value_state", unsigned: false, null: false
  end

  # TABLE: sensor_data_agg_1h
  # SQL: CREATE TABLE sensor_data_agg_1h ( `at` DateTime64(3, 'UTC'), `device_id` UInt32, `serial_number` String, `sensor_id` UInt32, `sensor_type_id` UInt16, `sum_value_state` AggregateFunction(sum, Int32), `max_value_state` AggregateFunction(max, Int32), `min_value_state` AggregateFunction(min, Int32), `avg_value_state` AggregateFunction(avg, Int32) ) ENGINE = SummingMergeTree PARTITION BY toYYYYMMDD(at) ORDER BY (device_id, serial_number, sensor_id, sensor_type_id, at) SETTINGS index_granularity = 8192
  create_table "sensor_data_agg_1h", id: false, options: "SummingMergeTree PARTITION BY toYYYYMMDD(at) ORDER BY (device_id, serial_number, sensor_id, sensor_type_id, at) SETTINGS index_granularity = 8192", force: :cascade do |t|
    t.datetime "at", precision: nil, null: false
    t.integer "device_id", null: false
    t.string "serial_number", null: false
    t.integer "sensor_id", null: false
    t.integer "sensor_type_id", limit: 2, null: false
    t.integer "sum_value_state", unsigned: false, null: false
    t.integer "max_value_state", unsigned: false, null: false
    t.integer "min_value_state", unsigned: false, null: false
    t.integer "avg_value_state", unsigned: false, null: false
  end

  # TABLE: sensor_data_agg_1m
  # SQL: CREATE TABLE sensor_data_agg_1m ( `at` DateTime64(3, 'UTC'), `device_id` UInt32, `serial_number` String, `sensor_id` UInt32, `sensor_type_id` UInt16, `sum_value_state` AggregateFunction(sum, Int32), `max_value_state` AggregateFunction(max, Int32), `min_value_state` AggregateFunction(min, Int32), `avg_value_state` AggregateFunction(avg, Int32) ) ENGINE = SummingMergeTree PARTITION BY toYYYYMMDD(at) ORDER BY (device_id, serial_number, sensor_id, sensor_type_id, at) SETTINGS index_granularity = 8192
  create_table "sensor_data_agg_1m", id: false, options: "SummingMergeTree PARTITION BY toYYYYMMDD(at) ORDER BY (device_id, serial_number, sensor_id, sensor_type_id, at) SETTINGS index_granularity = 8192", force: :cascade do |t|
    t.datetime "at", precision: nil, null: false
    t.integer "device_id", null: false
    t.string "serial_number", null: false
    t.integer "sensor_id", null: false
    t.integer "sensor_type_id", limit: 2, null: false
    t.integer "sum_value_state", unsigned: false, null: false
    t.integer "max_value_state", unsigned: false, null: false
    t.integer "min_value_state", unsigned: false, null: false
    t.integer "avg_value_state", unsigned: false, null: false
  end

  # TABLE: sensor_data_agg_6s
  # SQL: CREATE TABLE sensor_data_agg_6s ( `at` DateTime64(3, 'UTC'), `device_id` UInt32, `serial_number` String, `sensor_id` UInt32, `sensor_type_id` UInt16, `sum_value_state` AggregateFunction(sum, Int32), `max_value_state` AggregateFunction(max, Int32), `min_value_state` AggregateFunction(min, Int32), `avg_value_state` AggregateFunction(avg, Int32) ) ENGINE = SummingMergeTree PARTITION BY toYYYYMMDD(at) ORDER BY (device_id, serial_number, sensor_id, sensor_type_id, at) SETTINGS index_granularity = 8192
  create_table "sensor_data_agg_6s", id: false, options: "SummingMergeTree PARTITION BY toYYYYMMDD(at) ORDER BY (device_id, serial_number, sensor_id, sensor_type_id, at) SETTINGS index_granularity = 8192", force: :cascade do |t|
    t.datetime "at", precision: nil, null: false
    t.integer "device_id", null: false
    t.string "serial_number", null: false
    t.integer "sensor_id", null: false
    t.integer "sensor_type_id", limit: 2, null: false
    t.integer "sum_value_state", unsigned: false, null: false
    t.integer "max_value_state", unsigned: false, null: false
    t.integer "min_value_state", unsigned: false, null: false
    t.integer "avg_value_state", unsigned: false, null: false
  end

  # TABLE: sensor_data_raw
  # SQL: CREATE TABLE sensor_data_raw ( `at` DateTime64(3, 'UTC'), `device_id` UInt32, `serial_number` String, `sensor_id` UInt32, `sensor_type_id` UInt16, `raw_sensor_value` Int32, `numeric_sensor_value` Int32, `string_sensor_value` String, `boolean_sensor_value` UInt8, `is_active` UInt8, `is_idle` UInt8, `is_shutdown` UInt8, `is_nominal_sensor_value` UInt8, `idle_level` Int32, `min_nominal_value` Int32, `max_nominal_value` Int32, `power` UInt32 ) ENGINE = ReplacingMergeTree PARTITION BY toYYYYMMDD(at) ORDER BY (device_id, sensor_id, sensor_type_id, at) SETTINGS index_granularity = 8192
  create_table "sensor_data_raw", id: false, options: "ReplacingMergeTree PARTITION BY toYYYYMMDD(at) ORDER BY (device_id, sensor_id, sensor_type_id, at) SETTINGS index_granularity = 8192", force: :cascade do |t|
    t.datetime "at", precision: nil, null: false
    t.integer "device_id", null: false
    t.string "serial_number", null: false
    t.integer "sensor_id", null: false
    t.integer "sensor_type_id", limit: 2, null: false
    t.integer "raw_sensor_value", unsigned: false, null: false
    t.integer "numeric_sensor_value", unsigned: false, null: false
    t.string "string_sensor_value", null: false
    t.integer "boolean_sensor_value", limit: 1, null: false
    t.integer "is_active", limit: 1, null: false
    t.integer "is_idle", limit: 1, null: false
    t.integer "is_shutdown", limit: 1, null: false
    t.integer "is_nominal_sensor_value", limit: 1, null: false
    t.integer "idle_level", unsigned: false, null: false
    t.integer "min_nominal_value", unsigned: false, null: false
    t.integer "max_nominal_value", unsigned: false, null: false
    t.integer "power", null: false
  end

  # TABLE: sensor_data_agg_10m_mv
  # SQL: CREATE MATERIALIZED VIEW sensor_data_agg_10m_mv TO sensor_data_agg_10m ( `at` DateTime('UTC'), `device_id` UInt32, `serial_number` String, `sensor_id` UInt32, `sensor_type_id` UInt16, `sum_value_state` AggregateFunction(sum, Int32), `max_value_state` AggregateFunction(max, Int32), `min_value_state` AggregateFunction(min, Int32), `avg_value_state` AggregateFunction(avg, Int32) ) AS SELECT toStartOfInterval(at, toIntervalMinute(10)) AS at, device_id, serial_number, sensor_id, sensor_type_id, sumState(numeric_sensor_value) AS sum_value_state, maxState(numeric_sensor_value) AS max_value_state, minState(numeric_sensor_value) AS min_value_state, avgState(numeric_sensor_value) AS avg_value_state FROM sensor_data_raw GROUP BY (device_id, serial_number, sensor_id, sensor_type_id, at) ORDER BY (device_id, serial_number, sensor_id, sensor_type_id, at) ASC
  create_table "sensor_data_agg_10m_mv", view: true, materialized: true, to: "sensor_data_agg_10m", id: false, as: "SELECT toStartOfInterval(at, toIntervalMinute(10)) AS at, device_id, serial_number, sensor_id, sensor_type_id, sumState(numeric_sensor_value) AS sum_value_state, maxState(numeric_sensor_value) AS max_value_state, minState(numeric_sensor_value) AS min_value_state, avgState(numeric_sensor_value) AS avg_value_state FROM sensor_data_raw GROUP BY (device_id, serial_number, sensor_id, sensor_type_id, at) ORDER BY (device_id, serial_number, sensor_id, sensor_type_id, at) ASC", force: :cascade do |t|
  end

  # TABLE: sensor_data_agg_1h_mv
  # SQL: CREATE MATERIALIZED VIEW sensor_data_agg_1h_mv TO sensor_data_agg_1h ( `at` DateTime('UTC'), `device_id` UInt32, `serial_number` String, `sensor_id` UInt32, `sensor_type_id` UInt16, `sum_value_state` AggregateFunction(sum, Int32), `max_value_state` AggregateFunction(max, Int32), `min_value_state` AggregateFunction(min, Int32), `avg_value_state` AggregateFunction(avg, Int32) ) AS SELECT toStartOfInterval(at, toIntervalMinute(60)) AS at, device_id, serial_number, sensor_id, sensor_type_id, sumState(numeric_sensor_value) AS sum_value_state, maxState(numeric_sensor_value) AS max_value_state, minState(numeric_sensor_value) AS min_value_state, avgState(numeric_sensor_value) AS avg_value_state FROM sensor_data_raw GROUP BY (device_id, serial_number, sensor_id, sensor_type_id, at) ORDER BY (device_id, serial_number, sensor_id, sensor_type_id, at) ASC
  create_table "sensor_data_agg_1h_mv", view: true, materialized: true, to: "sensor_data_agg_1h", id: false, as: "SELECT toStartOfInterval(at, toIntervalMinute(60)) AS at, device_id, serial_number, sensor_id, sensor_type_id, sumState(numeric_sensor_value) AS sum_value_state, maxState(numeric_sensor_value) AS max_value_state, minState(numeric_sensor_value) AS min_value_state, avgState(numeric_sensor_value) AS avg_value_state FROM sensor_data_raw GROUP BY (device_id, serial_number, sensor_id, sensor_type_id, at) ORDER BY (device_id, serial_number, sensor_id, sensor_type_id, at) ASC", force: :cascade do |t|
  end

  # TABLE: sensor_data_agg_1m_mv
  # SQL: CREATE MATERIALIZED VIEW sensor_data_agg_1m_mv TO sensor_data_agg_1m ( `at` DateTime('UTC'), `device_id` UInt32, `serial_number` String, `sensor_id` UInt32, `sensor_type_id` UInt16, `sum_value_state` AggregateFunction(sum, Int32), `max_value_state` AggregateFunction(max, Int32), `min_value_state` AggregateFunction(min, Int32), `avg_value_state` AggregateFunction(avg, Int32) ) AS SELECT toStartOfInterval(at, toIntervalMinute(1)) AS at, device_id, serial_number, sensor_id, sensor_type_id, sumState(numeric_sensor_value) AS sum_value_state, maxState(numeric_sensor_value) AS max_value_state, minState(numeric_sensor_value) AS min_value_state, avgState(numeric_sensor_value) AS avg_value_state FROM sensor_data_raw GROUP BY (device_id, serial_number, sensor_id, sensor_type_id, at) ORDER BY (device_id, serial_number, sensor_id, sensor_type_id, at) ASC
  create_table "sensor_data_agg_1m_mv", view: true, materialized: true, to: "sensor_data_agg_1m", id: false, as: "SELECT toStartOfInterval(at, toIntervalMinute(1)) AS at, device_id, serial_number, sensor_id, sensor_type_id, sumState(numeric_sensor_value) AS sum_value_state, maxState(numeric_sensor_value) AS max_value_state, minState(numeric_sensor_value) AS min_value_state, avgState(numeric_sensor_value) AS avg_value_state FROM sensor_data_raw GROUP BY (device_id, serial_number, sensor_id, sensor_type_id, at) ORDER BY (device_id, serial_number, sensor_id, sensor_type_id, at) ASC", force: :cascade do |t|
  end

  # TABLE: sensor_data_agg_6s_mv
  # SQL: CREATE MATERIALIZED VIEW sensor_data_agg_6s_mv TO sensor_data_agg_6s ( `at` DateTime('UTC'), `device_id` UInt32, `serial_number` String, `sensor_id` UInt32, `sensor_type_id` UInt16, `sum_value_state` AggregateFunction(sum, Int32), `max_value_state` AggregateFunction(max, Int32), `min_value_state` AggregateFunction(min, Int32), `avg_value_state` AggregateFunction(avg, Int32) ) AS SELECT toStartOfInterval(at, toIntervalSecond(6)) AS at, device_id, serial_number, sensor_id, sensor_type_id, sumState(numeric_sensor_value) AS sum_value_state, maxState(numeric_sensor_value) AS max_value_state, minState(numeric_sensor_value) AS min_value_state, avgState(numeric_sensor_value) AS avg_value_state FROM sensor_data_raw GROUP BY (device_id, serial_number, sensor_id, sensor_type_id, at) ORDER BY (device_id, serial_number, sensor_id, sensor_type_id, at) ASC
  create_table "sensor_data_agg_6s_mv", view: true, materialized: true, to: "sensor_data_agg_6s", id: false, as: "SELECT toStartOfInterval(at, toIntervalSecond(6)) AS at, device_id, serial_number, sensor_id, sensor_type_id, sumState(numeric_sensor_value) AS sum_value_state, maxState(numeric_sensor_value) AS max_value_state, minState(numeric_sensor_value) AS min_value_state, avgState(numeric_sensor_value) AS avg_value_state FROM sensor_data_raw GROUP BY (device_id, serial_number, sensor_id, sensor_type_id, at) ORDER BY (device_id, serial_number, sensor_id, sensor_type_id, at) ASC", force: :cascade do |t|
  end

end
