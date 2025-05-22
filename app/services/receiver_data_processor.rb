class ReceiverDataProcessor
  def self.call(raw, device)
    new(raw, device).process
  end

  def initialize(raw, device)
    @raw = raw
    @device = device
    @now_time = (Time.now.to_f * 1000.0).to_i
  end

  def process
    data = parse_json(@raw)
    return error('error parse json') unless data

    update_device_info(data)

    return success unless @device.receive_data

    sensor_values = build_sensor_values(data)
    Sites::Devices::SensorValue.insert(sensor_values)

    success
  # rescue => e
  #   error("unexpected error", e)
  end

  private

  def parse_json(raw)
    return raw if raw.is_a?(Hash)
    JSON.parse(raw, symbolize_names: true)
  # rescue JSON::ParserError
  #   nil
  end

  def update_device_info(data)
    @device.update_columns(
      firmware_version: data[:firmware],
      remote_model_name: data[:model],
      last_online_at: Time.current,
      uptime: data[:uptime].to_i
    )
  end

  def build_sensor_values(data)
    creating_ts = data[:ts].to_i
    delay = @now_time - creating_ts

    sensors = @device.sensors.index_by { |s| s.sensor_type.data_key_name }

    data[:data].flat_map do |item|
      next [] if item[:ts].to_i == 0

      ts = item[:ts]
      at = ts / 1000.0

      item[:rfid_hold] = true if item.key?(:rfid_in)
      item[:rfid_hold] = false if item.key?(:rfid_out)

      log_raw(item[:Raw], at) if item[:Raw].present?

      item.each_with_object([]) do |(key, value), results|
        next unless value.is_a?(Numeric) || ['true', 'false'].include?(value.to_s.downcase)

        value = 1 if value.to_s.downcase == 'true'
        value = 0 if value.to_s.downcase == 'false'

        sensor = sensors[key.to_s]
        next unless sensor

        value_with_factor = sensor.calculate_value_factor(value)
        power = sensor.calculate_power_factor(value_with_factor)

        entry = {
          at: Time.at(at),
          device_id: @device.id,
          serial_number: @device.serial_number,
          sensor_id: sensor.id,
          idle_level: sensor.idle_level,
          shutdown_level: sensor.shutdown_level,
          sensor_type_id: sensor.sensor_type_id,
          numeric_sensor_value: value_with_factor,
          raw_sensor_value: value,
          power: power,
          is_active: (value_with_factor > sensor.idle_level ? 1 : 0),
          is_stopped: (value_with_factor > sensor.idle_level ? 0 : 1),
          is_shutdown: (value_with_factor >= sensor.shutdown_level ? 0 : 1),
          receiving_delay: delay
        }

        if key == :rfid_hold
          entry[:string_sensor_value] = item[:rfid]
          entry[:bool_sensor_value] = value
        end

        results << entry
      end
    end.compact.flatten
  end

  def log_raw(raw, timestamp)
    File.open("public/mb_raw.txt", "a") do |f|
      f.puts "#{Time.at(timestamp)} - #{raw}"
    end
  end

  def success
    { success: true }
  end

  def error(message, exception = nil)
    { success: false, message: message, exception: exception }
  end
end
