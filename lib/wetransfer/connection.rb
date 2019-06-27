module Wetransfer
  class Connection
    attr_accessor :client

    def initialize(client: ,logger: ::Logger.new(STDOUT))
      @client = client
      @logger = logger
    end

    def post_request(callback_url:, payload: )
      connection.post(callback_url, json: payload)
    end

    def get_request(callback_url: )
      connection.get(callback_url)
    end

    def connection
      HTTP.timeout(connect: 15, read: 30)
          .auth(client.bearer_token)
          .headers('x-api-key': client.api_key, 'Content-Type' => 'application/json')
          .use(logging: {logger: @logger})
    end

    def ensure_ok_response
    end
  end
end