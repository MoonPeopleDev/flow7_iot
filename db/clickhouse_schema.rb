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
  # TABLE: sensor_data_raw
  # SQL: CREATE TABLE sensor_data_raw ( `at` DateTime64(3, 'UTC'), `device_id` UInt32, `serial_number` String, `sensor_id` UInt32, `sensor_type_id` UInt16, `raw_sensor_value` Int32, `numeric_sensor_value` Int32, `string_sensor_value` String, `boolean_sensor_value` UInt8, `is_active` UInt8, `is_idle` UInt8, `is_shutdown` UInt8, `is_nominal_sensor_value` UInt8, `threshold_idle` Int32, `threshold_shutdown` Int32, `threshold_min_nominal_value` Int32, `threshold_max_nominal_value` Int32, `receiving_delay` Int32, `power` UInt32 ) ENGINE = ReplacingMergeTree PARTITION BY toYYYYMMDD(at) ORDER BY (device_id, sensor_id, sensor_type_id, at) SETTINGS index_granularity = 8192
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
    t.integer "threshold_idle", unsigned: false, null: false
    t.integer "threshold_shutdown", unsigned: false, null: false
    t.integer "threshold_min_nominal_value", unsigned: false, null: false
    t.integer "threshold_max_nominal_value", unsigned: false, null: false
    t.integer "receiving_delay", unsigned: false, null: false
    t.integer "power", null: false
  end

  # TABLE: sensor_data_rollup_10m
  # SQL: CREATE TABLE sensor_data_rollup_10m ( `at` DateTime64(3, 'UTC'), `device_id` UInt32, `serial_number` String, `sensor_id` UInt32, `sensor_type_id` UInt16, `avg_state` AggregateFunction(avg, Float64), `min_state` AggregateFunction(min, Int32), `max_state` AggregateFunction(max, Int32), `sum_state` AggregateFunction(sum, Int64), `cnt_state` AggregateFunction(count, UInt64) ) ENGINE = AggregatingMergeTree PARTITION BY toYYYYMMDD(at) ORDER BY (device_id, serial_number, sensor_id, sensor_type_id, at) SETTINGS index_granularity = 8192
  create_table "sensor_data_rollup_10m", id: false, options: "AggregatingMergeTree PARTITION BY toYYYYMMDD(at) ORDER BY (device_id, serial_number, sensor_id, sensor_type_id, at) SETTINGS index_granularity = 8192", force: :cascade do |t|
    t.datetime "at", precision: nil, null: false
    t.integer "device_id", null: false
    t.string "serial_number", null: false
    t.integer "sensor_id", null: false
    t.integer "sensor_type_id", limit: 2, null: false
    t.float "avg_state", null: false
    t.integer "min_state", unsigned: false, null: false
    t.integer "max_state", unsigned: false, null: false
    t.integer "sum_state", unsigned: false, limit: 8, null: false
    t.integer "cnt_state", limit: 8, null: false
  end

  # TABLE: sensor_data_rollup_10s
  # SQL: CREATE TABLE sensor_data_rollup_10s ( `at` DateTime64(3, 'UTC'), `device_id` UInt32, `serial_number` String, `sensor_id` UInt32, `sensor_type_id` UInt16, `avg_state` AggregateFunction(avg, Float64), `min_state` AggregateFunction(min, Int32), `max_state` AggregateFunction(max, Int32), `sum_state` AggregateFunction(sum, Int64), `cnt_state` AggregateFunction(count, UInt64) ) ENGINE = AggregatingMergeTree PARTITION BY toYYYYMMDD(at) ORDER BY (device_id, serial_number, sensor_id, sensor_type_id, at) SETTINGS index_granularity = 8192
  create_table "sensor_data_rollup_10s", id: false, options: "AggregatingMergeTree PARTITION BY toYYYYMMDD(at) ORDER BY (device_id, serial_number, sensor_id, sensor_type_id, at) SETTINGS index_granularity = 8192", force: :cascade do |t|
    t.datetime "at", precision: nil, null: false
    t.integer "device_id", null: false
    t.string "serial_number", null: false
    t.integer "sensor_id", null: false
    t.integer "sensor_type_id", limit: 2, null: false
    t.float "avg_state", null: false
    t.integer "min_state", unsigned: false, null: false
    t.integer "max_state", unsigned: false, null: false
    t.integer "sum_state", unsigned: false, limit: 8, null: false
    t.integer "cnt_state", limit: 8, null: false
  end

  # TABLE: sensor_data_rollup_1h
  # SQL: CREATE TABLE sensor_data_rollup_1h ( `at` DateTime64(3, 'UTC'), `device_id` UInt32, `serial_number` String, `sensor_id` UInt32, `sensor_type_id` UInt16, `avg_state` AggregateFunction(avg, Float64), `min_state` AggregateFunction(min, Int32), `max_state` AggregateFunction(max, Int32), `sum_state` AggregateFunction(sum, Int64), `cnt_state` AggregateFunction(count, UInt64) ) ENGINE = AggregatingMergeTree PARTITION BY toYYYYMMDD(at) ORDER BY (device_id, serial_number, sensor_id, sensor_type_id, at) SETTINGS index_granularity = 8192
  create_table "sensor_data_rollup_1h", id: false, options: "AggregatingMergeTree PARTITION BY toYYYYMMDD(at) ORDER BY (device_id, serial_number, sensor_id, sensor_type_id, at) SETTINGS index_granularity = 8192", force: :cascade do |t|
    t.datetime "at", precision: nil, null: false
    t.integer "device_id", null: false
    t.string "serial_number", null: false
    t.integer "sensor_id", null: false
    t.integer "sensor_type_id", limit: 2, null: false
    t.float "avg_state", null: false
    t.integer "min_state", unsigned: false, null: false
    t.integer "max_state", unsigned: false, null: false
    t.integer "sum_state", unsigned: false, limit: 8, null: false
    t.integer "cnt_state", limit: 8, null: false
  end

  # TABLE: sensor_data_rollup_1m
  # SQL: CREATE TABLE sensor_data_rollup_1m ( `at` DateTime64(3, 'UTC'), `device_id` UInt32, `serial_number` String, `sensor_id` UInt32, `sensor_type_id` UInt16, `avg_state` AggregateFunction(avg, Float64), `min_state` AggregateFunction(min, Int32), `max_state` AggregateFunction(max, Int32), `sum_state` AggregateFunction(sum, Int64), `cnt_state` AggregateFunction(count, UInt64) ) ENGINE = AggregatingMergeTree PARTITION BY toYYYYMMDD(at) ORDER BY (device_id, serial_number, sensor_id, sensor_type_id, at) SETTINGS index_granularity = 8192
  create_table "sensor_data_rollup_1m", id: false, options: "AggregatingMergeTree PARTITION BY toYYYYMMDD(at) ORDER BY (device_id, serial_number, sensor_id, sensor_type_id, at) SETTINGS index_granularity = 8192", force: :cascade do |t|
    t.datetime "at", precision: nil, null: false
    t.integer "device_id", null: false
    t.string "serial_number", null: false
    t.integer "sensor_id", null: false
    t.integer "sensor_type_id", limit: 2, null: false
    t.float "avg_state", null: false
    t.integer "min_state", unsigned: false, null: false
    t.integer "max_state", unsigned: false, null: false
    t.integer "sum_state", unsigned: false, limit: 8, null: false
    t.integer "cnt_state", limit: 8, null: false
  end

  # # TABLE: mv_rollup_10m
  # # SQL: CREATE MATERIALIZED VIEW mv_rollup_10m TO sensor_data_rollup_10m ( `at` DateTime('UTC'), `device_id` UInt32, `serial_number` String, `sensor_id` UInt32, `sensor_type_id` UInt16, `avg_state` AggregateFunction(avg, Float64), `min_state` AggregateFunction(min, Int32), `max_state` AggregateFunction(max, Int32), `sum_state` AggregateFunction(sum, Int64), `cnt_state` AggregateFunction(count, UInt64) ) AS SELECT toStartOfInterval(at, toIntervalMinute(10)) AS at, device_id, serial_number, sensor_id, sensor_type_id, avgMergeState(avg_state) AS avg_state, minMergeState(min_state) AS min_state, maxMergeState(max_state) AS max_state, sumMergeState(sum_state) AS sum_state, countMergeState(cnt_state) AS cnt_state FROM sensor_data_rollup_1m GROUP BY at, device_id, serial_number, sensor_id, sensor_type_id
  # create_table "mv_rollup_10m", view: true, materialized: true, to: "sensor_data_rollup_10m", id: false, as: "SELECT toStartOfInterval(at, toIntervalMinute(10)) AS at, device_id, serial_number, sensor_id, sensor_type_id, avgMergeState(avg_state) AS avg_state, minMergeState(min_state) AS min_state, maxMergeState(max_state) AS max_state, sumMergeState(sum_state) AS sum_state, countMergeState(cnt_state) AS cnt_state FROM sensor_data_rollup_1m GROUP BY at, device_id, serial_number, sensor_id, sensor_type_id", force: :cascade do |t|
  # end
  #
  # # TABLE: mv_rollup_10s
  # # SQL: CREATE MATERIALIZED VIEW mv_rollup_10s TO sensor_data_rollup_10s ( `at` DateTime('UTC'), `device_id` UInt32, `serial_number` String, `sensor_id` UInt32, `sensor_type_id` UInt16, `avg_state` AggregateFunction(avg, Float64), `min_state` AggregateFunction(min, Int32), `max_state` AggregateFunction(max, Int32), `sum_state` AggregateFunction(sum, Int64), `cnt_state` AggregateFunction(count) ) AS SELECT toStartOfInterval(at, toIntervalSecond(10)) AS at, device_id, serial_number, sensor_id, sensor_type_id, avgState(toFloat64(numeric_sensor_value)) AS avg_state, minState(numeric_sensor_value) AS min_state, maxState(numeric_sensor_value) AS max_state, sumState(toInt64(numeric_sensor_value)) AS sum_state, countState() AS cnt_state FROM sensor_data_raw GROUP BY at, device_id, serial_number, sensor_id, sensor_type_id
  # create_table "mv_rollup_10s", view: true, materialized: true, to: "sensor_data_rollup_10s", id: false, as: "SELECT toStartOfInterval(at, toIntervalSecond(10)) AS at, device_id, serial_number, sensor_id, sensor_type_id, avgState(toFloat64(numeric_sensor_value)) AS avg_state, minState(numeric_sensor_value) AS min_state, maxState(numeric_sensor_value) AS max_state, sumState(toInt64(numeric_sensor_value)) AS sum_state, countState() AS cnt_state FROM sensor_data_raw GROUP BY at, device_id, serial_number, sensor_id, sensor_type_id", force: :cascade do |t|
  # end
  #
  # # TABLE: mv_rollup_1h
  # # SQL: CREATE MATERIALIZED VIEW mv_rollup_1h TO sensor_data_rollup_1h ( `at` DateTime('UTC'), `device_id` UInt32, `serial_number` String, `sensor_id` UInt32, `sensor_type_id` UInt16, `avg_state` AggregateFunction(avg, Float64), `min_state` AggregateFunction(min, Int32), `max_state` AggregateFunction(max, Int32), `sum_state` AggregateFunction(sum, Int64), `cnt_state` AggregateFunction(count, UInt64) ) AS SELECT toStartOfHour(at) AS at, device_id, serial_number, sensor_id, sensor_type_id, avgMergeState(avg_state) AS avg_state, minMergeState(min_state) AS min_state, maxMergeState(max_state) AS max_state, sumMergeState(sum_state) AS sum_state, countMergeState(cnt_state) AS cnt_state FROM sensor_data_rollup_10m GROUP BY at, device_id, serial_number, sensor_id, sensor_type_id
  # create_table "mv_rollup_1h", view: true, materialized: true, to: "sensor_data_rollup_1h", id: false, as: "SELECT toStartOfHour(at) AS at, device_id, serial_number, sensor_id, sensor_type_id, avgMergeState(avg_state) AS avg_state, minMergeState(min_state) AS min_state, maxMergeState(max_state) AS max_state, sumMergeState(sum_state) AS sum_state, countMergeState(cnt_state) AS cnt_state FROM sensor_data_rollup_10m GROUP BY at, device_id, serial_number, sensor_id, sensor_type_id", force: :cascade do |t|
  # end
  #
  # # TABLE: mv_rollup_1m
  # # SQL: CREATE MATERIALIZED VIEW mv_rollup_1m TO sensor_data_rollup_1m ( `at` DateTime('UTC'), `device_id` UInt32, `serial_number` String, `sensor_id` UInt32, `sensor_type_id` UInt16, `avg_state` AggregateFunction(avg, Float64), `min_state` AggregateFunction(min, Int32), `max_state` AggregateFunction(max, Int32), `sum_state` AggregateFunction(sum, Int64), `cnt_state` AggregateFunction(count, UInt64) ) AS SELECT toStartOfMinute(at) AS at, device_id, serial_number, sensor_id, sensor_type_id, avgMergeState(avg_state) AS avg_state, minMergeState(min_state) AS min_state, maxMergeState(max_state) AS max_state, sumMergeState(sum_state) AS sum_state, countMergeState(cnt_state) AS cnt_state FROM sensor_data_rollup_10s GROUP BY at, device_id, serial_number, sensor_id, sensor_type_id
  # create_table "mv_rollup_1m", view: true, materialized: true, to: "sensor_data_rollup_1m", id: false, as: "SELECT toStartOfMinute(at) AS at, device_id, serial_number, sensor_id, sensor_type_id, avgMergeState(avg_state) AS avg_state, minMergeState(min_state) AS min_state, maxMergeState(max_state) AS max_state, sumMergeState(sum_state) AS sum_state, countMergeState(cnt_state) AS cnt_state FROM sensor_data_rollup_10s GROUP BY at, device_id, serial_number, sensor_id, sensor_type_id", force: :cascade do |t|
  # end

end
