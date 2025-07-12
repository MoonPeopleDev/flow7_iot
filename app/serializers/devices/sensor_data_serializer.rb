class Devices::SensorDataSerializer
  include JSONAPI::Serializer
  set_type :sensor_received_data

  attributes :sensor_type, :data, :general

  attribute :sensor_type do |sensor|
    Devices::SensorTypeSerializer.new(sensor.sensor_type).serializable_hash[:data][:attributes]
  end

  attribute :data do |sensor, params|
    d = params[:data]
    case sensor.sensor_type.data_key_name
    when 'rfid_hold'
      [{ at: ((d.from - 1.second).to_i * 1000) }] +
        d.timeline.map { |row| { at: (row.at.to_i * 1000).to_i, rfid: row.string_value, v: (row.bool_value == 1 ? 'in' : 'out'), personnel_id: row.respond_to?(:personnel_id) ? row.personnel_id : nil } } +
        [{ at: ((d.to + 1.second).to_i * 1000) }]
    when 'rfid'
      out = d.timeline.map { |row| { at: (row.at.to_i * 1000).to_i, rfid: row.value } }
      [{ at: ((d.from - 1.second).to_i * 1000) }] + out + [{ at: ((d.to + 1.second).to_i * 1000) }]
    else
      [{ at: ((d.from - 1.second).to_i * 1000) }] +
        d.timeline.map { |row| { at: (row.at.to_i * 1000).to_i, v: row.value } } +
        [{ at: ((d.to + 1.second).to_i * 1000) }]
    end
  end

  attribute :general do |sensor, params|
    params[:data].general
  end
end
