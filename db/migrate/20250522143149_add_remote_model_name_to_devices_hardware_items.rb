class AddRemoteModelNameToDevicesHardwareItems < ActiveRecord::Migration[7.2]
  def change
    add_column :devices_hardware_items, :remote_model_name, :string
  end
end
