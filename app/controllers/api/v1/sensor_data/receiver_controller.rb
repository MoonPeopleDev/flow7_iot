class Api::V1::SensorData::ReceiverController < Api::V1::BaseController
  before_action :find_device_hardware_item, only: [:receive]

  def ping
    render json: { result: 'ok' }, status: 200
  end

  def receive
    key = @device.aes_key
    iv = @device.aes_iv
    if key.nil? || iv.nil?
      process_data(request.raw_post)
    else
      begin
        cipher = OpenSSL::Cipher::AES.new(128, :CBC)
        cipher.decrypt
        cipher.key = key
        cipher.iv = iv
        # cipher.padding = 0

        encrypted_data = request.raw_post.b
        plain = (cipher.update(encrypted_data) + cipher.final).strip
      rescue => e
        log_error("error decrypt data", e)
        render json: { result: 'error decrypt data' }, status: 400 and return
      end
      process_data(plain)
    end
  end

  private

  def process_data(raw)
    result = ReceiverDataProcessor.call(raw, @device)

    if result[:success]
      render json: { result: 'ok' }, status: 200
    else
      log_error(result[:message], result[:exception])
      render json: { result: result[:message] }, status: 400
    end
  end

  def find_device_hardware_item
    serial_number = request.headers["X-Serial-Number"]
    @device = Devices::HardwareItem.find_by!(serial_number: serial_number)
  end

  def log_error(message, exception = nil)
    File.write("public/debug_parse_error.txt", "#{Time.current.to_s(:db)}\n#{message}\n#{exception&.message}")
  end
end
