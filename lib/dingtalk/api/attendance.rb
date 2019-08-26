module Dingtalk
  module Api
    class Attendance < Base
      def list(params)
        http_post("list?access_token=#{access_token}", params)
      end

      def list_record(user_dingtalk_ids, start_time, end_time, is_i18n)
        params = {
          "userIds": user_dingtalk_ids,
          "checkDateFrom": start_time.strftime("%Y-%m-%d %H:%M:%S"),
          "checkDateTo": end_time.strftime("%Y-%m-%d %H:%M:%S"),
          "isI18n": is_i18n.to_s ## user 'not' in China or not
        }
        http_post("listRecord?access_token=#{access_token}", params)
      end

      def get_leave_approve_duration(user_dingtalk_id, from_date, to_date)
        params = {
          "userid": user_dingtalk_id,
          "from_date": from_date.strftime("%Y-%m-%d %H:%M:%S"),
          "to_date": to_date.strftime("%Y-%m-%d %H:%M:%S")
        }
        http_post("getleaveapproveduration?access_token=#{access_token}", params)
      end

      def getleavestatus(params)
        http_post("getleavestatus?access_token=#{access_token}", params)
      end

      private

      def base_url
        'attendance'
      end

    end
  end
end
