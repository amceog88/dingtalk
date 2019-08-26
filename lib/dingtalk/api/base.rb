module Dingtalk
  module Api
    class Base
      ACCESS_TOKEN = "access_token"
      JS_TICKET = "js_ticket"

      def initialize(app = nil)
        @app = app
      end

      def access_token
        token = @app.access_token
        token.to_s.empty? ? set_access_token : token
      end

      def set_access_token
        if !@app.appsecret.nil?
          set_app_access_token
        end
      end

      def js_ticket
        ticket = redis.get("#{@app.app_id}_#{JS_TICKET}")
        ticket.to_s.empty? ? set_js_ticket : ticket
      end

      def set_app_access_token
        res = http_get("#{ENDPOINT}/gettoken?appkey=#{@app.appkey}&appsecret=#{@app.appsecret}")
        @app.update(access_token: res['access_token'])
      end

      def set_js_ticket
        key = "#{@app.app_id}_#{JS_TICKET}"
        res = http_get("#{ENDPOINT}/get_jsapi_ticket?access_token=#{access_token}")
        redis.set(key, res['ticket'])
        # redis.expire(key, res['expires_in'])
        redis.expire(key, 6600)
        redis.get(key)
      end

    private

      def default_params
        { access_token: access_token }
      end

      def payload(url, params)
        [ request_url(url), {
          params: default_params.merge(params).to_json,
          content_type: :json
        }]
      end

      def http_get(url, params = {})
        res = RestClient.get(request_url(url))
        JSON.parse(res)
      end

      def http_post(url, params = {})
        p = default_params.merge(params)
        res = RestClient.post(request_url(url), p.to_json, content_type: :json)
        JSON.parse(res)
      end

      def base_url
        ''
      end

      def request_url(url)
        if url.start_with?('https')
          url
        else
          "#{ENDPOINT}/#{base_url}/#{url}"
        end
      end

      def redis
        Dingtalk.dingtalk_redis
      end

    end
  end
end
