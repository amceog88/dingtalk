module Dingtalk
  module Api
    class Message < Base
      # def send_with(params)
      #   http_post("send?access_token=#{access_token}", params)
      # end

      def send_working_message(params)
        http_post("asyncsend_v2?access_token=#{access_token}", params)
      end

    private
      def base_url
        # 'message'
        'topapi/message/corpconversation'
      end
    end
  end
end
