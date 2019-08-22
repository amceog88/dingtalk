module Dingtalk
  module Api
    class MicroApp < Base
      def visible_scopes(agent_id)
        http_post("visible_scopes?access_token=#{access_token}", { agentId: agent_id })
      end

      def list
        http_post("list?access_token=#{access_token}")
      end

      private
        def base_url
          'microapp'
        end
    end
  end
end

