module Dingtalk
    module Api
      class Approve < Base
        
        def processinstance_create(params)
          http_post("processinstance/create=#{access_token}", params)
        end

        def processinstance_listids(params)
          http_post("processinstance/listids=#{access_token}", params)
        end

        def process_list_by_userid(params)
          http_post("process/listbyuserid=#{access_token}", params)
        end

        def save_process(params)
          http_post("process/save=#{access_token}", params)
        end

        def delete_process(params)
          http_post("process/delete=#{access_token}", params)
        end
  
      private
  
        def base_url
          'topapi'
        end
  
      end
    end
  end