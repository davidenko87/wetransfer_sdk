describe Wetransfer do
  let(:file_location) { %w[japan.jpg] }

  it 'create_transfer returns true' do
    client = Wetransfer::Client.new(api_key: ENV['WT_API_KEY'])
    resp = loop{client.create_transfer(message: 'foo', files: [{name: File.basename(__FILE__), io: File.open(__FILE__, 'rb')}])}
    expect(resp['success']).to be true
    expect(resp['message']).to match 'foo'
    expect(resp['files'].count).to be (1)
  end
end