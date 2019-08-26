module Dingtalk
  module Api
    class MicroApp < Base
      def visible_scopes(agent_id)
        http_post("visible_scopes?access_token=#{access_token}", { agentId: agent_id })
      end

      def list
        http_post("list?access_token=#{access_token}")
      end

      def update_app_setting(agent_id, is_hidden, dept_visible_scopes)
        params = {
          "agentId": agent_id,
          "isHidden": is_hidden,
          "deptVisibleScopes": dept_visible_scopes
        }
        http_post("set_visible_scopes?access_token=#{access_token}", params)
      end

      def list_by_userid(user_id)
        http_get("list_by_userid?access_token=#{access_token}&userid=#{user_id}")
      end

    private

      def base_url
        'microapp'
      end
    end
  end
end

