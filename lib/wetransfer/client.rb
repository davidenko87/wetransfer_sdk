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
      resp = @connection.post_request(callback_url: "#{@api_url_base}/v2/transfers",
                               payload: transfer.request_params)
      # need to store return values from api
      # update transfer_id and file_ids
      binding.pry
      resp.parse

      get_upload_urls(transfer: transfer)
    end

    private

    def get_upload_urls(transfer:)
      transfer.files.each do |file|
        request_upload_url(transfer_id: transfer.id,)
      end
    end

    def request_upload_url(transfer_id:, file_id:, part_number:)
      @connection.get_request(callback_url: "#{@api_url_base}/v2/transfers/#{transfer_id}/files/#{file_id}/upload-url/#{part_number}")
    end

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