module Dingtalk
  module Api
    class Message < Base

      def send_working_message(message, dingtalk_user_ids)
        params = {
          "agent_id": @app.agent_id,
          "userid_list": dingtalk_user_ids,
          "to_all_user": false,
          "msg": {
            "msgtype": 'text',
            "text": {
              "content": message
            }
          }
        }
        http_post("asyncsend_v2?access_token=#{access_token}", params)
      end

    private
      def base_url
        'topapi/message/corpconversation'
      end
    end
  end
end
