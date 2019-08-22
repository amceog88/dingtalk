module Dingtalk
  class Client
    def initialize(app = nil)
      @app = app
    end

    def decrypt(echo_str)
      content, status = Dingtalk::Prpcrypt.decrypt(aes_key, echo_str, Dingtalk.suite_key)
      # TODO check status
      JSON.parse(content)
    end

    def response_json(return_str)
      the_timestamp = timestamp
      the_nonce = nonce
      encrypted = encrypt(return_str)
      {
        msg_signature: signature(return_str, encrypted, the_timestamp, the_nonce),
        encrypt: encrypted,
        timeStamp: the_timestamp,
        nonce: the_nonce
      }
    end

    def encrypt(return_str)
      encrypt = Dingtalk::Prpcrypt.encrypt(aes_key, return_str, Dingtalk.suite_key)
    end

    def signature(return_str, encrypted, the_timestamp, the_nonce)
      sort_params = [Dingtalk.suite_token, the_timestamp, the_nonce, encrypted].sort.join
      Digest::SHA1.hexdigest(sort_params)
    end

    def jssign_package(request_url)
      return nil unless @app

      the_timestamp = timestamp
      the_nonce = nonce
      str = "jsapi_ticket=#{base.js_ticket}&noncestr=#{the_nonce}&timestamp=#{the_timestamp}&url=#{CGI.unescape(request_url)}"
      signature = Digest::SHA1.hexdigest(str)
      {
        js_ticket: base.js_ticket,
        request_url: request_url,
        app_id: @app.app_id,
        timeStamp: the_timestamp,
        nonceStr: the_nonce,
        signature: signature
      }
    end

    def base
      Api::Base.new(@app)
    end

    def suite
      Api::Suite.new
    end

    def sns
      Api::Sns.new
    end

    def department
      Api::Department.new(@app)
    end

    def user
      Api::User.new(@app)
    end

    def attendance
      Api::Attendance.new(@app)
    end

    def message
      Api::Message.new(@app)
    end

    def micro_app
      Api::MicroApp.new(@app)
    end

    def call_back
      Api::CallBack.new(@app)
    end

    private
      def aes_key
        Base64.decode64(Dingtalk.suite_aes_key + '=')
      end

      def timestamp
        Time.now.to_i.to_s
      end

      def nonce
        SecureRandom.hex
      end
  end
end
