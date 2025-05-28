class SensorsData < ActiveRecord::Migration[7.2]
  def up
    
    execute <<~SQL
        CREATE TABLE sensor_data_raw (
          at DateTime64(3,'UTC'),
          device_id UInt32,          
          serial_number String,
          sensor_id UInt32,
          sensor_type_id UInt16,
          raw_sensor_value Int32,
          numeric_sensor_value Int32,
          string_sensor_value String,
          boolean_sensor_value UInt8,
          
          is_active UInt8,
          is_idle UInt8,
          is_shutdown UInt8,
          is_nominal_sensor_value UInt8,
          
          threshold_idle Int32,
          threshold_shutdown Int32,
          threshold_min_nominal_value Int32,
          threshold_max_nominal_value Int32,
          receiving_delay Int32,
          power UInt32
        ) ENGINE=ReplacingMergeTree
        PARTITION BY (toYYYYMMDD(at))
        ORDER BY (device_id, sensor_id, sensor_type_id, at)
    SQL
    
    
    execute <<~SQL
        CREATE TABLE sensor_data_rollup_10s
        (
            at              DateTime64(3, 'UTC'),
        
            device_id       UInt32,
            serial_number   String,
            sensor_id       UInt32,
            sensor_type_id  UInt16,
        
            /* агрегаты-состояния */
            avg_state  AggregateFunction(avg,   Float64),
            min_state  AggregateFunction(min,   Int32),
            max_state  AggregateFunction(max,   Int32),
            sum_state  AggregateFunction(sum,   Int64),
            cnt_state  AggregateFunction(count, UInt64)
        )
        ENGINE = AggregatingMergeTree
        PARTITION BY toYYYYMMDD(at)
        ORDER BY (device_id, serial_number, sensor_id, sensor_type_id, at)
    SQL


    execute <<~SQL
        CREATE MATERIALIZED VIEW mv_rollup_10s
        TO sensor_data_rollup_10s AS
        SELECT
            toStartOfInterval(at, INTERVAL 10 second)                AS at,
            device_id,
            serial_number,
            sensor_id,
            sensor_type_id,
        
            avgState(toFloat64(numeric_sensor_value))                AS avg_state,
            minState(numeric_sensor_value)                           AS min_state,
            maxState(numeric_sensor_value)                           AS max_state,
            sumState(toInt64(numeric_sensor_value))                  AS sum_state,
            countState()                                             AS cnt_state
        FROM sensor_data_raw
        GROUP BY
            at, device_id, serial_number, sensor_id, sensor_type_id

    SQL

    execute <<~SQL
        CREATE TABLE sensor_data_rollup_1m
        (
            at              DateTime64(3, 'UTC'),
        
            device_id       UInt32,
            serial_number   String,
            sensor_id       UInt32,
            sensor_type_id  UInt16,
        
            /* агрегаты-состояния */
            avg_state  AggregateFunction(avg,   Float64),
            min_state  AggregateFunction(min,   Int32),
            max_state  AggregateFunction(max,   Int32),
            sum_state  AggregateFunction(sum,   Int64),
            cnt_state  AggregateFunction(count, UInt64)
        )
        ENGINE = AggregatingMergeTree
        PARTITION BY toYYYYMMDD(at)
        ORDER BY (device_id, serial_number, sensor_id, sensor_type_id, at)
    SQL


    execute <<~SQL
        CREATE MATERIALIZED VIEW mv_rollup_1m
        TO sensor_data_rollup_1m AS
        SELECT
            toStartOfMinute(at)                                      AS at,
            device_id,
            serial_number,
            sensor_id,
            sensor_type_id,
        
            avgMergeState(avg_state)  AS avg_state,
            minMergeState(min_state)  AS min_state,
            maxMergeState(max_state)  AS max_state,
            sumMergeState(sum_state)  AS sum_state,
            countMergeState(cnt_state) AS cnt_state
        FROM sensor_data_rollup_10s
        GROUP BY
            at, device_id, serial_number, sensor_id, sensor_type_id

    SQL

    execute <<~SQL
        CREATE TABLE sensor_data_rollup_10m
        (
            at              DateTime64(3, 'UTC'),
        
            device_id       UInt32,
            serial_number   String,
            sensor_id       UInt32,
            sensor_type_id  UInt16,
        
            /* агрегаты-состояния */
            avg_state  AggregateFunction(avg,   Float64),
            min_state  AggregateFunction(min,   Int32),
            max_state  AggregateFunction(max,   Int32),
            sum_state  AggregateFunction(sum,   Int64),
            cnt_state  AggregateFunction(count, UInt64)
        )
        ENGINE = AggregatingMergeTree
        PARTITION BY toYYYYMMDD(at)
        ORDER BY (device_id, serial_number, sensor_id, sensor_type_id, at)
    SQL


    execute <<~SQL
        CREATE MATERIALIZED VIEW mv_rollup_10m
        TO sensor_data_rollup_10m AS
        SELECT
            toStartOfInterval(at, INTERVAL 10 minute)                AS at,
            device_id,
            serial_number,
            sensor_id,
            sensor_type_id,
        
            avgMergeState(avg_state)  AS avg_state,
            minMergeState(min_state)  AS min_state,
            maxMergeState(max_state)  AS max_state,
            sumMergeState(sum_state)  AS sum_state,
            countMergeState(cnt_state) AS cnt_state
        FROM sensor_data_rollup_1m
        GROUP BY
            at, device_id, serial_number, sensor_id, sensor_type_id

    SQL

    execute <<~SQL
        CREATE TABLE sensor_data_rollup_1h
        (
            at              DateTime64(3, 'UTC'),
        
            device_id       UInt32,
            serial_number   String,
            sensor_id       UInt32,
            sensor_type_id  UInt16,
        
            /* агрегаты-состояния */
            avg_state  AggregateFunction(avg,   Float64),
            min_state  AggregateFunction(min,   Int32),
            max_state  AggregateFunction(max,   Int32),
            sum_state  AggregateFunction(sum,   Int64),
            cnt_state  AggregateFunction(count, UInt64)
        )
        ENGINE = AggregatingMergeTree
        PARTITION BY toYYYYMMDD(at)
        ORDER BY (device_id, serial_number, sensor_id, sensor_type_id, at)
    SQL


    execute <<~SQL
        CREATE MATERIALIZED VIEW mv_rollup_1h
        TO sensor_data_rollup_1h AS
        SELECT
            toStartOfHour(at)                                        AS at,
            device_id,
            serial_number,
            sensor_id,
            sensor_type_id,
        
            avgMergeState(avg_state)  AS avg_state,
            minMergeState(min_state)  AS min_state,
            maxMergeState(max_state)  AS max_state,
            sumMergeState(sum_state)  AS sum_state,
            countMergeState(cnt_state) AS cnt_state
        FROM sensor_data_rollup_10m
        GROUP BY
            at, device_id, serial_number, sensor_id, sensor_type_id

    SQL
  end
end
