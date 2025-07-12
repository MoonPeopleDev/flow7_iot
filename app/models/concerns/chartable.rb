module Chartable
  extend ActiveSupport::Concern

  class_methods do
    def chart_data(sensor_id, between, select_data)
      count = (between.last - between.first).to_i / self::INTERVAL
      query = <<~SQL
              SELECT
                  at,
                  avg(value) AS value,
                  avg(min_value) AS min_value,
                  avg(max_value) AS max_value
              FROM
              (
                  SELECT
                      toStartOfInterval(toDateTime(#{between.first.to_i} + number * #{self::INTERVAL}), toIntervalSecond(#{self::INTERVAL})) AS at,
                      NULL AS value,
                      NULL AS min_value,
                      NULL AS max_value
                  FROM numbers(#{count})
                  UNION ALL
                  SELECT
                      toStartOfInterval(at, toIntervalSecond(#{self::INTERVAL})) AS at,
                      #{select_data}
                  FROM #{self.table_name}
                  WHERE (at >= toDateTime(#{between.first.to_i})) AND (at <= toDateTime(#{between.last.to_i}))  AND (sensor_id = #{sensor_id})
                  GROUP BY at
        )
              GROUP BY at
              ORDER BY at ASC
      SQL
      find_by_sql(query)
    end
  end
end
