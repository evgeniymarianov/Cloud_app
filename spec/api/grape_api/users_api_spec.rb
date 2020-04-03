# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GrapeApi::UsersApi do
  describe 'GET /api/users' do
    it 'has a 200 status code' do
      get '/api/users'
      expect(response.status).to eq(200)
    end

    it 'has a array body' do
      get '/api/users'
      expect(JSON.parse(response.body)).to be_instance_of(Array)
    end

    it 'returns user attributes' do
      get '/api/users'
      users = JSON.parse(response.body)
      expect(users[0].keys).to contain_exactly('id', 'full_name', 'age')
    end

    it 'filter by ballance'
  end
end
