module Wetransfer
  class Client
    attr_accessor :bearer_token, :api_key

    def initialize(api_key:)
      @api_url_base = 'https://dev.wetransfer.com'
      @api_key = api_key.to_str
      @bearer_token = get_bearer_token
      @connection = establize_connection
    end

    def create_transfer(message:, files:)
      transfer = Wetransfer::Transfer.new(message: message)
      files.each do |file|
        transfer.add_file(name: file[:name], io: file[:io])
      end
      @connection.post_request(callback_url: "#{@api_url_base}/v2/transfers",
                               payload: transfer.request_params)


    end

    private

    def establize_connection
      Wetransfer::Connection.new(client: self)
    end

    def get_bearer_token
      return if @bearer_token
      puts ' getting bearer token'
      @bearer_token = "Bearer #{set_header.parse['token']}"
    end

    def set_header
      HTTP.headers('x-api-key': @api_key, 'Content-Type' => 'application/json').post("#{@api_url_base}/v2/authorize", body: '{}')
    end
  end
end