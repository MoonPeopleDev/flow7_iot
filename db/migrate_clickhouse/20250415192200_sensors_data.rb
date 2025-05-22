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
          power UInt32
        ) ENGINE=ReplacingMergeTree
        PARTITION BY (toYYYYMMDD(at))
        ORDER BY (device_id, sensor_id, sensor_type_id, at)
    SQL
    
    
    execute <<~SQL
           CREATE TABLE sensor_data_agg_6s (
               at DateTime64(3,'UTC'),
               device_id UInt32,
               serial_number String,
               sensor_id UInt32,
               sensor_type_id UInt16,
               sum_value_state AggregateFunction(sum, Int32),
               max_value_state AggregateFunction(max, Int32),
               min_value_state AggregateFunction(min, Int32),
               avg_value_state AggregateFunction(avg, Int32)
             ) ENGINE=SummingMergeTree()
             PARTITION BY (toYYYYMMDD(at))
             ORDER BY (device_id, serial_number, sensor_id, sensor_type_id, at)
    SQL


    execute <<~SQL
      CREATE MATERIALIZED VIEW sensor_data_agg_6s_mv
      TO sensor_data_agg_6s
      AS SELECT
          toStartOfInterval(at, INTERVAL 6 second) as at,
          device_id,
          serial_number,
          sensor_id,
          sensor_type_id,
          sumState(numeric_sensor_value) AS sum_value_state,
          maxState(numeric_sensor_value) AS max_value_state,
          minState(numeric_sensor_value) AS min_value_state,
          avgState(numeric_sensor_value) AS avg_value_state
      FROM sensor_data_raw
      GROUP BY (device_id, serial_number, sensor_id, sensor_type_id, at)
      ORDER BY (device_id, serial_number, sensor_id, sensor_type_id, at)

    SQL

    execute <<~SQL
           CREATE TABLE sensor_data_agg_1m (
               at DateTime64(3,'UTC'),
               device_id UInt32,
               serial_number String,
               sensor_id UInt32,
               sensor_type_id UInt16,
               sum_value_state AggregateFunction(sum, Int32),
               max_value_state AggregateFunction(max, Int32),
               min_value_state AggregateFunction(min, Int32),
               avg_value_state AggregateFunction(avg, Int32)

             ) ENGINE=SummingMergeTree()
             PARTITION BY (toYYYYMMDD(at))
             ORDER BY (device_id, serial_number, sensor_id, sensor_type_id, at)
    SQL


    execute <<~SQL
      CREATE MATERIALIZED VIEW sensor_data_agg_1m_mv
      TO sensor_data_agg_1m
      AS SELECT
          toStartOfInterval(at, INTERVAL 1 minute) as at,
          device_id,
          serial_number,
          sensor_id,
          sensor_type_id,
          sumState(numeric_sensor_value) AS sum_value_state,
          maxState(numeric_sensor_value) AS max_value_state,
          minState(numeric_sensor_value) AS min_value_state,
          avgState(numeric_sensor_value) AS avg_value_state

      FROM sensor_data_raw
      GROUP BY (device_id, serial_number, sensor_id, sensor_type_id, at)
      ORDER BY (device_id, serial_number, sensor_id, sensor_type_id, at)

    SQL

    execute <<~SQL
           CREATE TABLE sensor_data_agg_10m (
               at DateTime64(3,'UTC'),
               device_id UInt32,
               serial_number String,
               sensor_id UInt32,
               sensor_type_id UInt16,
               sum_value_state AggregateFunction(sum, Int32),
               max_value_state AggregateFunction(max, Int32),
               min_value_state AggregateFunction(min, Int32),
               avg_value_state AggregateFunction(avg, Int32)
             ) ENGINE=SummingMergeTree()
             PARTITION BY (toYYYYMMDD(at))
             ORDER BY (device_id, serial_number, sensor_id, sensor_type_id, at)
    SQL


    execute <<~SQL
      CREATE MATERIALIZED VIEW sensor_data_agg_10m_mv
      TO sensor_data_agg_10m
      AS SELECT
          toStartOfInterval(at, INTERVAL 10 minute) as at,
          device_id,
          serial_number,
          sensor_id,
          sensor_type_id,
          sumState(numeric_sensor_value) AS sum_value_state,
          maxState(numeric_sensor_value) AS max_value_state,
          minState(numeric_sensor_value) AS min_value_state,
          avgState(numeric_sensor_value) AS avg_value_state

      FROM sensor_data_raw
      GROUP BY (device_id, serial_number, sensor_id, sensor_type_id, at)
      ORDER BY (device_id, serial_number, sensor_id, sensor_type_id, at)

    SQL

    execute <<~SQL
           CREATE TABLE sensor_data_agg_1h (
               at DateTime64(3,'UTC'),
               device_id UInt32,
               serial_number String,
               sensor_id UInt32,
               sensor_type_id UInt16,
               sum_value_state AggregateFunction(sum, Int32),
               max_value_state AggregateFunction(max, Int32),
               min_value_state AggregateFunction(min, Int32),
               avg_value_state AggregateFunction(avg, Int32)

             ) ENGINE=SummingMergeTree()
             PARTITION BY (toYYYYMMDD(at))
             ORDER BY (device_id, serial_number, sensor_id, sensor_type_id, at)
    SQL


    execute <<~SQL
      CREATE MATERIALIZED VIEW sensor_data_agg_1h_mv
      TO sensor_data_agg_1h
      AS SELECT
          toStartOfInterval(at, INTERVAL 60 minute) as at,
          device_id,
          serial_number,
          sensor_id,
          sensor_type_id,
          sumState(numeric_sensor_value) AS sum_value_state,
          maxState(numeric_sensor_value) AS max_value_state,
          minState(numeric_sensor_value) AS min_value_state,
          avgState(numeric_sensor_value) AS avg_value_state

      FROM sensor_data_raw
      GROUP BY (device_id, serial_number, sensor_id, sensor_type_id, at)
      ORDER BY (device_id, serial_number, sensor_id, sensor_type_id, at)

    SQL
  end
end
