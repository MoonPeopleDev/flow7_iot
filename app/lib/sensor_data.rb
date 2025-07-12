class SensorData
  VALID_SCALABLES = ['avg', 'max', 'min', 'sum', 'diff', 'avg_no_zeros']
  VALID_CAPACITIES = ['raw', '10s', '1m', '10m', '1h']

  def initialize(sensor, between, capacity, _scalable_by = nil)
    @sensor = sensor
    @between = between
    @sensor_type = @sensor.sensor_type
    @capacity = VALID_CAPACITIES.include?(capacity) ? capacity : nil
    @scalable_by = VALID_SCALABLES.include?(_scalable_by) ? _scalable_by : nil
  end

  def from
    @between.first
  end

  def to
    @between.last
  end

  def timeline
    if @sensor_type.scalable
      data = case capacity
              when 'raw'
                Devices::SensorValue.chart_data(@sensor.id, @between, 'max(value) as value, null as min_value, null as max_value')
              when '10s'
                SensorData::Rollup10s.chart_data(@sensor.id, @between, select)
              when '1m'
                SensorData::Rollup1m.chart_data(@sensor.id, @between, select)
              when '10m'
                SensorData::Rollup10m.chart_data(@sensor.id, @between, select)
              when '1h'
                SensorData::Rollup1h.chart_data(@sensor.id, @between, select)
              end
      prepare_data(data)
    else
      @sensor.sensor_data_raw.select('at, millis, value, string_value, bool_value').where(at: @between).order(:at)
    end
  end

  def prepare_data(data)
    if @scalable_by == 'diff' && capacity != 'raw'
      prev_max = nil
      data.each do |item|
        if !prev_max.nil? && !item.max_value.nil?
          item.value = item.max_value - prev_max
        end
        prev_max = item.max_value unless item.max_value.nil?
      end
      data
    else
      data
    end
  end

  def capacity
    return @capacity if @capacity.present?
    period = to - from
    case period
    when 0..1500
      'raw'
    when 1500..15000
      '10s'
    when 15000..150000
      '1m'
    when 150000..1500000
      '10m'
    else
      '1h'
    end
  end

  def scalable_by
    @scalable_by.present? ? @scalable_by : @sensor_type.scalable_by
  end

  def select
    case scalable_by
    when 'avg'
      'avgMerge(avg_value_state) as value, null as min_value, null as max_value'
    when 'max'
      'maxMerge(max_value_state) as value, null as min_value, null as max_value '
    when 'min'
      'minMerge(min_value_state) as value, null as min_value, null as max_value'
    when 'sum'
      'sumMerge(sum_value_state) as value, null as min_value, null as max_value'
    when 'diff'
      'maxMerge(max_value_state) - minMerge(min_value_state) as value, minMerge(min_value_state) as min_value, maxMerge(max_value_state) as max_value'
    end
  end

  def general
    send("general_#{@sensor_type.general_data_method}")
  end

  private

  def general_none
    nil
  end

  def general_sum
    where = {at: @between }
    agg_select = 'sumMerge(sum_value_state) as sum_value'
    res = case @between.last - @between.first
          when 0..1500
            @sensor.sensor_data_raw.where(where).group(:sensor_id).select('sum(value) as sum_value').order(:sensor_id).first
          when 1500..15000
            @sensor.sensor_data_10s.where(where).group(:sensor_id).select(agg_select).order(:sensor_id).first
          when 15000..150000
            @sensor.sensor_data_1m.where(where).group(:sensor_id).select(agg_select).order(:sensor_id).first
          when 150000..1500000
            @sensor.sensor_data_10m.where(where).group(:sensor_id).select(agg_select).order(:sensor_id).first
          else
            @sensor.sensor_data_1h.where(where).group(:sensor_id).select(agg_select).order(:sensor_id).first
          end
    { min: res&.sum_value }
  end

  def general_min_max_average
    where = { at: @between }
    agg_select = 'maxMerge(max_value_state) as max_value, minMerge(min_value_state) as min_value, avgMerge(avg_value_state) as avg_value'
    res = case @between.last - @between.first
          when 0..1500
            @sensor.sensor_data_raw.order(:sensor_id).where(where).group(:sensor_id).select('max(value) as max_value, avg(value) as avg_value, min(value) as min_value').first
          when 1500..15000
            @sensor.sensor_data_10s.order(:sensor_id).where(where).group(:sensor_id).select(agg_select).first
          when 15000..150000
            @sensor.sensor_data_1m.order(:sensor_id).where(where).group(:sensor_id).select(agg_select).first
          when 150000..1500000
            @sensor.sensor_data_10m.order(:sensor_id).where(where).group(:sensor_id).select(agg_select).first
          else
            @sensor.sensor_data_1h.order(:sensor_id).where(where).group(:sensor_id).select(agg_select).first
          end
    { min: res&.min_value, max: res&.max_value, avg: res&.avg_value }
  end

  def general_min_max_diff
    where = { at: @between }
    agg_select = 'maxMerge(max_value_state) as max_value, minMerge(min_value_state) as min_value,  max_value - min_value as diff_value'
    res = case @between.last - @between.first
          when 0..1500
            @sensor.sensor_data_raw.order(:sensor_id).where(where).group(:sensor_id).select('max(value) as max_value, min(value) as min_value, max_value - min_value as diff_value').first
          when 1500..15000
            @sensor.sensor_data_10s.order(:sensor_id).where(where).group(:sensor_id).select(agg_select).first
          when 15000..150000
            @sensor.sensor_data_1m.order(:sensor_id).where(where).group(:sensor_id).select(agg_select).first
          when 150000..1500000
            @sensor.sensor_data_10m.order(:sensor_id).where(where).group(:sensor_id).select(agg_select).first
          else
            @sensor.sensor_data_1h.order(:sensor_id).where(where).group(:sensor_id).select(agg_select).first
          end
    { min: res&.min_value, max: res&.max_value, avg: res&.diff_value }
  end

  def general_work_idle_times
    work_time = @sensor.sensor_data_10s.where(at: @between).count.to_i * 10
    res = { work_time: work_time, idle_time: all_time - work_time }
    res[:idle_time] = 0 if res[:idle_time] < 0
    res
  end

  def general_rfid_touch_times
    nil
  end

  def general_rfid_hold_times
    res = {}
    last_rfid = nil
    last_event = nil
    last_event_at = nil
    @sensor.sensor_data_raw.where(at: @between).order(:at).all.each do |event|
      event_bool = (event.bool_value == 1)
      res[event.string_value] = 0 if res[event.string_value].nil?
      if last_rfid.nil? && last_event.nil?
        res[event.string_value] += (event.at - @between.first) unless event_bool
      else
        res[last_rfid] += (event.at - last_event_at) if last_event
      end
      last_rfid = event.string_value
      last_event = event_bool
      last_event_at = event.at
    end
    res[last_rfid] += (@between.last - last_event_at) if last_event
    res
  end

  def all_time
    first_data_at = @sensor.sensor_data_raw.order(:at).first&.at
    return 0 unless first_data_at.present?
    start = @between.first > first_data_at ? @between.first : first_data_at
    finish = @between.last > Time.now ? Time.now : @between.last
    finish - start rescue 0
  end
end
