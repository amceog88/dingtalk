module Dingtalk
  module Api
    class TopapiAttendance < Base
      def listschedule(work_date)
        http_post("listschedule?access_token=#{access_token}", { workDate: work_date })
      end

      def getsimplegroups
        params = {
          "offset": 0,
          "size": 10
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

    private

      def base_url
        'topapi/attendance'
      end
    end
  end
end
