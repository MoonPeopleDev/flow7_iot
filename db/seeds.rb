# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


[
  { name: 'Ток', description: 'Датчик тока', data_key_name: 'i', scalable: true, scalable_by: 'max', general_data_method: 'work_idle_times' },
  { name: 'Напряжение', description: 'Датчик напряжения', data_key_name: 'u', scalable: true, scalable_by: 'max', general_data_method: 'work_idle_times' },
  { name: 'Температура', description: 'Датчик температуры', data_key_name: 't', scalable: true, scalable_by: 'avg', general_data_method: 'min_max_average' },
  { name: 'Карта приложена', description: 'Карта приложена', data_key_name: 'rfid', scalable: false, scalable_by: 'avg', general_data_method: 'rfid_touch_times' },
  { name: 'Карта вставлена', description: 'Карта вставлена', data_key_name: 'rfid_hold', scalable: false, scalable_by: 'avg', general_data_method: 'rfid_hold_times' },
  { name: 'Температура воздуха', description: 'Датчик температуры воздуха', data_key_name: 't_air', scalable: true, scalable_by: 'avg', general_data_method: 'min_max_average' },
  { name: 'Угол', description: 'Датчик угла', data_key_name: 'ang', scalable: true, scalable_by: 'avg', general_data_method: 'none' },
  { name: 'Газ', description: 'Датчик газа', data_key_name: 'gas', scalable: true, scalable_by: 'sum', general_data_method: 'sum' },
  { name: 'Проволока', description: 'Датчик проволоки', data_key_name: 'wire', scalable: true, scalable_by: 'sum', general_data_method: 'sum' },
  { name: 'Газ_1', description: 'Датчик газа 1', data_key_name: 'gas1', scalable: true, scalable_by: 'max', general_data_method: 'work_idle_times' },
  { name: 'Газ_2', description: 'Датчик газа 2', data_key_name: 'gas2', scalable: true, scalable_by: 'max', general_data_method: 'work_idle_times' },

  { name: 'Ток средний', description: 'Датчик среднего переменного тока', data_key_name: 'ac_avg', scalable: true, scalable_by: 'max', general_data_method: 'work_idle_times' },
  { name: 'Ток среднеквадратический', description: 'Датчик среднеквадратического переменного тока', data_key_name: 'ac_rms', scalable: true, scalable_by: 'max', general_data_method: 'work_idle_times' },
  { name: 'Ток максимальный', description: 'Датчик максимального переменного тока', data_key_name: 'ac_max', scalable: true, scalable_by: 'max', general_data_method: 'work_idle_times' },
  { name: 'Ток минимальный', description: 'Датчик минимального переменного тока', data_key_name: 'ac_min', scalable: true, scalable_by: 'max', general_data_method: 'work_idle_times' },

  { :name => "mb_status", :description => "mb_status", :data_key_name => "mb_status", :scalable => true, :scalable_by => "max", :general_data_method => "work_idle_times" },
  { :name => "mb_status_stanok", :description => "mb_status_stanok", :data_key_name => "mb_status_stanok", :scalable => true, :scalable_by => "max", :general_data_method => "work_idle_times" },
  { :name => "mb_status_cicle", :description => "mb_status_cicle", :data_key_name => "mb_status_cicle", :scalable => true, :scalable_by => "max", :general_data_method => "work_idle_times" },
  { :name => "mb_status_prostoi", :description => "mb_status_prostoi", :data_key_name => "mb_status_prostoi", :scalable => true, :scalable_by => "max", :general_data_method => "work_idle_times" },
  { :name => "mb_status_error", :description => "mb_status_error", :data_key_name => "mb_status_error", :scalable => true, :scalable_by => "max", :general_data_method => "work_idle_times" },
  { :name => "mb_status_mess", :description => "mb_status_mess", :data_key_name => "mb_status_mess", :scalable => true, :scalable_by => "max", :general_data_method => "work_idle_times" },
  { :name => "mb_tw", :description => "mb_tw", :data_key_name => "mb_tw", :scalable => true, :scalable_by => "max", :general_data_method => "work_idle_times" },
  { :name => "mb_twh", :description => "mb_twh", :data_key_name => "mb_twh", :scalable => true, :scalable_by => "max", :general_data_method => "work_idle_times" },
  { :name => "mb_tsh", :description => "mb_tsh", :data_key_name => "mb_tsh", :scalable => true, :scalable_by => "max", :general_data_method => "work_idle_times" },
  { :name => "mb_tsm", :description => "mb_tsm", :data_key_name => "mb_tsm", :scalable => true, :scalable_by => "max", :general_data_method => "work_idle_times" },
  { :name => "mb_cycle", :description => "mb_cycle", :data_key_name => "mb_cycle", :scalable => true, :scalable_by => "max", :general_data_method => "work_idle_times" },
  { :name => "mb_stop", :description => "mb_stop", :data_key_name => "mb_stop", :scalable => true, :scalable_by => "max", :general_data_method => "work_idle_times" },
  { :name => "mb_speed", :description => "mb_speed", :data_key_name => "mb_speed", :scalable => true, :scalable_by => "max", :general_data_method => "work_idle_times" },
  { :name => "mb_len", :description => "mb_len", :data_key_name => "mb_len", :scalable => true, :scalable_by => "max", :general_data_method => "work_idle_times" },
  { :name => "mb_lenf", :description => "mb_lenf", :data_key_name => "mb_lenf", :scalable => true, :scalable_by => "max", :general_data_method => "work_idle_times" },
  { :name => "mb_br_t", :description => "mb_br_t", :data_key_name => "mb_br_t", :scalable => true, :scalable_by => "max", :general_data_method => "work_idle_times" },
  { :name => "mb_br_f", :description => "mb_br_f", :data_key_name => "mb_br_f", :scalable => true, :scalable_by => "max", :general_data_method => "work_idle_times" },
  { :name => "mb_nt_t", :description => "mb_nt_t", :data_key_name => "mb_nt_t", :scalable => true, :scalable_by => "max", :general_data_method => "work_idle_times" },
  { :name => "mb_nt_f", :description => "mb_nt_f", :data_key_name => "mb_nt_f", :scalable => true, :scalable_by => "max", :general_data_method => "work_idle_times" },
  { :name => "mb_weight", :description => "mb_weight", :data_key_name => "mb_weight", :scalable => true, :scalable_by => "max", :general_data_method => "work_idle_times" },
  { :name => "mb_thikness", :description => "mb_thikness", :data_key_name => "mb_thikness", :scalable => true, :scalable_by => "max", :general_data_method => "work_idle_times" },
  { :name => "mb_width", :description => "mb_width", :data_key_name => "mb_width", :scalable => true, :scalable_by => "max", :general_data_method => "work_idle_times" },
  { :name => "mb_mn_t", :description => "mb_mn_t", :data_key_name => "mb_mn_t", :scalable => true, :scalable_by => "max", :general_data_method => "work_idle_times" },
  { :name => "mb_mn_f", :description => "mb_mn_f", :data_key_name => "mb_mn_f", :scalable => true, :scalable_by => "max", :general_data_method => "work_idle_times" },
  { :name => "mb_mn_teor", :description => "mb_mn_teor", :data_key_name => "mb_mn_teor", :scalable => true, :scalable_by => "max", :general_data_method => "work_idle_times" },
  { :name => "mb_br_teor", :description => "mb_br_teor", :data_key_name => "mb_br_teor", :scalable => true, :scalable_by => "max", :general_data_method => "work_idle_times" },
  { :name => "mb_on", :description => "mb_on", :data_key_name => "mb_on", :scalable => true, :scalable_by => "max", :general_data_method => "work_idle_times" },
  { :name => "mb_cyc", :description => "mb_cyc", :data_key_name => "mb_cyc", :scalable => true, :scalable_by => "max", :general_data_method => "work_idle_times" },
  { :name => "mb_speedt", :description => "mb_speedt", :data_key_name => "mb_speedt", :scalable => true, :scalable_by => "max", :general_data_method => "work_idle_times" },
  { :name => "mb_meter", :description => "mb_meter", :data_key_name => "mb_meter", :scalable => true, :scalable_by => "max", :general_data_method => "work_idle_times" },
  { :name => "mb_count", :description => "mb_count", :data_key_name => "mb_count", :scalable => true, :scalable_by => "max", :general_data_method => "work_idle_times" },

  { name: 'Фаза 1 ток RMS', description: 'Фаза 1 ток RMS', data_key_name: 'phase_1_i_rms', scalable: true, scalable_by: 'max', general_data_method: 'work_idle_times' },
  { name: 'Фаза 1 напряжение RMS', description: 'Фаза 1 напряжение RMS', data_key_name: 'phase_1_u_rms', scalable: true, scalable_by: 'max', general_data_method: 'work_idle_times' },
  { name: 'Фаза 1 real power', description: 'Фаза 1 real power', data_key_name: 'phase_1_real_power', scalable: true, scalable_by: 'max', general_data_method: 'work_idle_times' },

  { name: 'Фаза 2 ток RMS', description: 'Фаза 2 ток RMS', data_key_name: 'phase_2_i_rms', scalable: true, scalable_by: 'max', general_data_method: 'work_idle_times' },
  { name: 'Фаза 2 напряжение RMS', description: 'Фаза 2 напряжение RMS', data_key_name: 'phase_2_u_rms', scalable: true, scalable_by: 'max', general_data_method: 'work_idle_times' },
  { name: 'Фаза 2 real power', description: 'Фаза 2 real power', data_key_name: 'phase_2_real_power', scalable: true, scalable_by: 'max', general_data_method: 'work_idle_times' },

  { name: 'Фаза 3 ток RMS', description: 'Фаза 3 ток RMS', data_key_name: 'phase_3_i_rms', scalable: true, scalable_by: 'max', general_data_method: 'work_idle_times' },
  { name: 'Фаза 3 напряжение RMS', description: 'Фаза 3 напряжение RMS', data_key_name: 'phase_3_u_rms', scalable: true, scalable_by: 'max', general_data_method: 'work_idle_times' },
  { name: 'Фаза 3 real power', description: 'Фаза 3 real power', data_key_name: 'phase_3_real_power', scalable: true, scalable_by: 'max', general_data_method: 'work_idle_times' },





].each { |st| Devices::SensorType.create(st) }