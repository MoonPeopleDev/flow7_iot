class Devices::Sensor < ApplicationRecord
  belongs_to :sensor_type, class_name: 'Devices::SensorType', foreign_key: :sensor_type_id
  belongs_to :hardware_item, class_name: 'Devices::HardwareItem', foreign_key: :hardware_item_id
  has_many :sensor_data_raw, class_name: 'SensorData::Raw', foreign_key: :sensor_id
  has_many :sensor_data_10s, class_name: 'SensorData::Rollup10s', foreign_key: :sensor_id
  has_many :sensor_data_1m, class_name: 'SensorData::Rollup1m', foreign_key: :sensor_id
  has_many :sensor_data_10m, class_name: 'SensorData::Rollup10m', foreign_key: :sensor_id
  has_many :sensor_data_1h, class_name: 'SensorData::Rollup1h', foreign_key: :sensor_id
  validates :name, presence: true
  enum :algo, { base: 0, async_algo: 1 }
  validates :cycle_threshold, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 600 }

  validate do |item|
    if item.value_factor.present?
      if item.factor.to_s =~ /\A[0-9\-+*\/V().]+\z/
        formula = item.factor.to_s.gsub('V', 1.to_s)
        begin
          eval(formula)
        rescue
          item.errors.add(:factor, 'Неверная формула')
        end
      else
        item.errors.add(:factor, 'Неверная формула')
      end
    end

    if item.power_factor.present?
      if item.power_factor.to_s =~ /\A[0-9\-+*\/V().]+\z/
        formula = item.power_factor.to_s.gsub('V', 1.to_s)
        begin
          eval(formula)
        rescue
          item.errors.add(:power_factor, 'Неверная формула')
        end
      else
        item.errors.add(:power_factor, 'Неверная формула')
      end
    end
  end

  def online?
    hardware_item.online?
  end

  def online
    online?
  end

  def data_key_name
    sensor_type.try(:data_key_name)
  end

  def calculate_value_factor(value)
    value = 0 if value < 0
    return 0 unless value.is_a?(Numeric)
    return value unless value_factor.present?
    value = value.to_f
    formula = value_factor.to_s.gsub('V', value.to_s)
    begin
      eval(formula).round
    rescue
      0
    end
  end

  def calculate_power_factor(value)
    return 0 unless value.is_a?(Numeric)
    return 0 unless power_factor.present?
    value = value.to_f
    formula = power_factor.to_s.gsub('V', value.to_s)
    begin
      eval(formula).round
    rescue
      0
    end
  end
end
