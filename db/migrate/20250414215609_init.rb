class Init < ActiveRecord::Migration[7.2]
  def change

    create_table :devices_hardware_models do |t|
      t.string :name
      t.string :description
      t.timestamps
    end

    create_table :devices_sensor_types do |t|
      t.string :name
      t.string :data_key_name
      t.string :description
      t.boolean :scalable, default: false, null: false
      t.integer :scalable_by, default: 0, null: false
      t.integer :general_data_method, default: 0, null: false
      t.integer :chart_type, default: 0, null: false
      t.timestamps
    end

    create_table :devices_hardware_items do |t|
      t.string :name
      t.string :description
      t.references :hardware_model, null: false, foreign_key: { to_table: :devices_hardware_models }, index: true
      t.string :serial_number
      t.datetime :last_online_at
      t.string :firmware_version
      t.integer :uptime, default: 0, null: false
      t.boolean :receive_data, default: true, null: false
      t.binary :aes_key
      t.timestamps
    end

    create_table :devices_sensors do |t|
      t.string :name
      t.string :description
      t.references :sensor_type, null: false, foreign_key: { to_table: :devices_sensor_types }, index: true
      t.references :hardware_item, null: false, foreign_key: { to_table: :devices_hardware_items }, index: true
      #t.integer :threshold_active, default: 3, null: false
      t.integer :threshold_idle, default: 0, null: false
      t.integer :threshold_shutdown, default: 0, null: false
      #t.integer :cycle_threshold, default: 0, null: false
      #t.integer :algo, default: 0, null: false
      t.string :value_factor
      t.string :power_factor
      t.timestamps
    end

    create_join_table :devices_hardware_models, :devices_sensor_types do |t|
      t.index [:devices_hardware_model_id, :devices_sensor_type_id], name: 'index_dhm_dst_on_model_and_type'
      t.index [:devices_sensor_type_id, :devices_hardware_model_id], name: 'index_dst_dhm_on_type_and_model'
    end
  end
end