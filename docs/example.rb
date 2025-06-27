def received_data
  between = parse_times
  data = SensorReceivedData.new(current_site, @sensor, between, params[:capacity], params[:scalable_by])
  render json: @sensor, serializer: Sites::Devices::SensorReceivedDataSerializer, scope: { data: data }
end

def parse_times
  from = params[:from].present? ? Time.zone.parse(params[:from]) : nil
  to = params[:to].present? ? (Time.zone.parse(params[:to])) : nil
  raise ActionController::ParameterMissing.new('from and to') if from.nil? || to.nil?
  from..to
end

class SensorReceivedData
  VALID_SCALABLES = ['avg', 'max', 'min', 'sum', 'diff', 'avg_no_zeros']
  VALID_CAPACITIES = ['raw', 'six_second', 'one_minute', 'ten_minute', 'one_hour']

  def initialize(site, sensor, between, capacity, _scalable_by = nil)
    @site = site
    @sensor = sensor
    @between = between
    @sensor_type = @sensor.sensor_type
    @capacity = (VALID_CAPACITIES.include?(capacity) ? capacity : nil)
    @scalable_by = (VALID_SCALABLES.include?(_scalable_by) ? _scalable_by : nil)
  end

  def from
    @between.first
  end

  def to
    @between.last
  end

  def timeline
    if @sensor_type.scalable
      if capacity == 'raw'
        #@sensor.sensor_values.select("at, value").where(at: @between).order(:at)
        data = Sites::Devices::SensorValue.chart_data(@site.id, @sensor.id, @between, 'max(value) as value, null as min_value, null as max_value')
      elsif capacity == 'six_second'
        data = Sites::Devices::SensorValueBySixSecond.chart_data(@site.id, @sensor.id, @between, select)
      elsif capacity == 'one_minute'
        data = Sites::Devices::SensorValueByMinute.chart_data(@site.id, @sensor.id, @between, select)
      elsif capacity == 'ten_minute'
        data = Sites::Devices::SensorValueByTenMinute.chart_data(@site.id, @sensor.id, @between, select)
      elsif capacity == 'one_hour'
        data = Sites::Devices::SensorValueByHour.chart_data(@site.id, @sensor.id, @between, select)
      end
      prepare_data(data)
    else
      @sensor.sensor_values.select("at, millis, value, string_value, bool_value").where(at: @between).order(:at)
    end
  end

  def prepare_data(data)
    if @scalable_by == 'diff' && capacity != 'raw'
      prev_max = nil
      data.each do |item|
        if !prev_max.nil? && !item.max_value.nil?
          item.value = item.max_value - prev_max
        end
        unless item.max_value.nil?
          prev_max = item.max_value
        end
      end
      data
    else
      data
    end
  end


  def capacity
    return @capacity if @capacity.present?
    period = to - from
    case
    when period.between?(0, 1500)
      'raw'
    when period.between?(1500, 15000)
      'six_second'
    when period.between?(15000, 150000)
      'one_minute'
    when period.between?(150000, 1500000)
      'ten_minute'
    else
      'one_hour'
    end
  end

  def scalable_by
    @scalable_by.present? ? @scalable_by : @sensor_type.scalable_by
  end

  def select
    case scalable_by
    when 'avg'
      "avgMerge(avg_value_state) as value, null as min_value, null as max_value"
    when 'max'
      "maxMerge(max_value_state) as value, null as min_value, null as max_value "
    when 'min'
      "minMerge(min_value_state) as value, null as min_value, null as max_value"
    when 'sum'
      "sumMerge(sum_value_state) as value, null as min_value, null as max_value"
    when 'diff'
      "maxMerge(max_value_state) - minMerge(min_value_state) as value, minMerge(min_value_state) as min_value, maxMerge(max_value_state) as max_value"
    end
  end

  def general
    self.send("general_#{@sensor_type.general_data_method}")
  end

  private

  def general_none
    nil
  end

  def general_sum
    where = { site_id: @site.id, at: @between }
    agg_select = "sumMerge(sum_value_state) as sum_value"
    res = case @between.last - @between.first
          when 0..1500
            @sensor.sensor_values.where(where).group(:sensor_id).select("sum(value) as sum_value").order(:sensor_id).first
          when 1500..15000
            @sensor.sensor_values_by_six_seconds.where(where).group(:sensor_id).select(agg_select).order(:sensor_id).first
          when 15000..150000
            @sensor.sensor_values_by_minutes.where(where).group(:sensor_id).select(agg_select).order(:sensor_id).first
          when 150000..1500000
            @sensor.sensor_values_by_ten_minutes.where(where).group(:sensor_id).select(agg_select).order(:sensor_id).first
          else
            @sensor.sensor_values_by_hours.where(where).group(:sensor_id).select(agg_select).order(:sensor_id).first
          end
    {
      min: res&.sum_value
    }
  end

  def general_min_max_average
    where = { site_id: @site.id, at: @between }
    agg_select = "maxMerge(max_value_state) as max_value, minMerge(min_value_state) as min_value, avgMerge(avg_value_state) as avg_value"
    res = case @between.last - @between.first
          when 0..1500
            @sensor.sensor_values.order(:sensor_id).where(where).group(:sensor_id).select("max(value) as max_value, avg(value) as avg_value, min(value) as min_value").first
          when 1500..15000
            @sensor.sensor_values_by_six_seconds.order(:sensor_id).where(where).group(:sensor_id).select(agg_select).first
          when 15000..150000
            @sensor.sensor_values_by_minutes.order(:sensor_id).where(where).group(:sensor_id).select(agg_select).first
          when 150000..1500000
            @sensor.sensor_values_by_ten_minutes.order(:sensor_id).where(where).group(:sensor_id).select(agg_select).first
          else
            @sensor.sensor_values_by_hours.order(:sensor_id).where(where).group(:sensor_id).select(agg_select).first
          end
    {
      min: res&.min_value,
      max: res&.max_value,
      avg: res&.avg_value,
    }
  end

  def general_min_max_diff
    where = { site_id: @site.id, at: @between }
    agg_select = "maxMerge(max_value_state) as max_value, minMerge(min_value_state) as min_value,  max_value - min_value as diff_value"
    res = case @between.last - @between.first
          when 0..1500
            @sensor.sensor_values.order(:sensor_id).where(where).group(:sensor_id).select("max(value) as max_value, min(value) as min_value, max_value - min_value as diff_value").first
          when 1500..15000
            @sensor.sensor_values_by_six_seconds.order(:sensor_id).where(where).group(:sensor_id).select(agg_select).first
          when 15000..150000
            @sensor.sensor_values_by_minutes.order(:sensor_id).where(where).group(:sensor_id).select(agg_select).first
          when 150000..1500000
            @sensor.sensor_values_by_ten_minutes.order(:sensor_id).where(where).group(:sensor_id).select(agg_select).first
          else
            @sensor.sensor_values_by_hours.order(:sensor_id).where(where).group(:sensor_id).select(agg_select).first
          end
    {
      min: res&.min_value,
      max: res&.max_value,
      avg: res&.diff_value,
    }
  end

  def general_work_idle_times
    work_time = @sensor.sensor_values_by_six_seconds.where(site_id: @site.id, at: @between).count.to_i * 6
    res = {
      work_time: work_time,
      idle_time: all_time - work_time
    }
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
    @sensor.sensor_values.where(site_id: @site.id, at: @between).order(:at).all.each do |event|
      event_bool = (event.bool_value == 1)
      res[event.string_value] = 0 if res[event.string_value].nil?
      if last_rfid.nil? && last_event.nil?
        if !event_bool
          res[event.string_value] += (event.at - @between.first)
        end
      else
        if last_event
          res[last_rfid] += (event.at - last_event_at)
        end
      end
      last_rfid = event.string_value
      last_event = event_bool
      last_event_at = event.at
    end
    if last_event
      res[last_rfid] += (@between.last - last_event_at)
    end
    res
  end

  def all_time
    first_data_at = @sensor.sensor_values.where(site_id: @site.id).order(:at).first&.at
    return 0 unless first_data_at.present?
    if @between.first > first_data_at
      start = @between.first
    else
      start = first_data_at
    end
    if @between.last > Time.now
      finish = Time.now
    else
      finish = @between.last
    end
    finish - start rescue 0
  end

end