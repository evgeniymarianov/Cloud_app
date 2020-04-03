# frozen_string_literal: true

require 'rails_helper'
require 'json'

RSpec.describe 'Widget management' do
  it 'has a array body' do
    client = HTTPClient.new
    response = client.request(get 'http://localhost:3000/orders/check/?cpu=8&ram=4&hdd_type=sata&hdd_capacity=75&os=linux', { credits: 1000 }.to_json)
    #get '/orders/check/?cpu=8&ram=4&hdd_type=sata&hdd_capacity=75&os=linux', 
    expect(JSON.parse(response.body)).to be_instance_of(Array)
  end
end
