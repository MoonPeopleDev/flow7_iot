class AddCycleThresholdAndAlgoToDevicesSensors < ActiveRecord::Migration[7.2]
  def change
    add_column :devices_sensors, :cycle_threshold, :integer, default: 0, null: false
    add_column :devices_sensors, :algo, :integer, default: 0, null: false
    change_column_default :devices_sensors, :threshold_idle, from: 2, to: 0
    change_column_default :devices_sensors, :threshold_shutdown, from: 1, to: 0
  end
end
