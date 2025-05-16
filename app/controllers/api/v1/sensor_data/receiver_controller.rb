class Api::V1::SensorData::ReceiverController < Api::V1::BaseController
  before_action :find_device_hardware_item, only: [:receive]

  def ping
    render json: { result: 'ok' }, status: 200
  end

  def receive
    unless @device.aes_key.present?
      @device.aes_key = SecureRandom.random_bytes(16)
      @device.save!
      key_base64 = Base64.strict_encode64(@device.aes_key)
      render plain: "K:#{key_base64}"
      return
    end

    iv_base64 = request.headers["X-Nonce"]
    pp "iv_base64: #{iv_base64}"
    unless iv_base64.present?
      render plain: "Nonce not found", status: 400
      return
    end
    iv = Base64.decode64(request.headers["X-Nonce"].to_s)

    begin
      cipher = OpenSSL::Cipher::AES.new(128, :CBC)
      cipher.decrypt
      cipher.key = @device.aes_key
      cipher.iv = iv
      cipher.padding = 0

      request.raw_post.force_encoding('BINARY')
      encrypted_data = request.raw_post
      plain = (cipher.update(encrypted_data) + cipher.final).strip
    rescue => e
      Rails.logger.error("error decrypt data: #{e.class.to_s}")
      Rails.logger.error("error decrypt data: #{e.message}")
      Rails.logger.error("error decrypt data: #{e.backtrace.join("\n")}")
      #log_error("error decrypt data", e)
      render plain: "error decrypt data", status: 400
      return
    end
    process_data(plain)
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
    serial_number = request.headers["X-Device-ID"]
    @device = Devices::HardwareItem.find_by!(serial_number: serial_number)
  end

  def log_error(message, exception = nil)
    File.write("public/debug_parse_error.txt", "#{Time.current.to_s(:db)}\n#{message}\n#{exception&.message}")
  end
end
