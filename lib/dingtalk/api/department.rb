module Dingtalk
  module Api
    class Department < Base
      def get(id)
        http_get("get?access_token=#{access_token}&id=#{id}")
      end

      def list
        http_get("list?access_token=#{access_token}")
      end

      def create(params)
        http_post("create?access_token=#{access_token}", params)
      end

      def update(params)
        http_post("update?access_token=#{access_token}", params)
      end

      def delete(id)
        http_get("delete?access_token=#{access_token}&id=#{id}")
      end

      private
        def base_url
          'department'
        end
    end
  end
end
