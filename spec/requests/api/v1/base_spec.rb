require 'rails_helper'
RSpec.describe LibraryApp::API::V1::Base do
  let(:user) { create(:user) }
  let(:headers) do
    { 'Authorization' => "Bearer #{create(:doorkeeper_app).secret}" }
  end

  context 'POST /api/library_app/v1/users/authenticate' do
    it 'should return status 200 on correct credentials' do
      post '/api/library_app/v1/users/authenticate',
           params: { email: user.email, password: user.password }, headers: headers
      expect(response.body).to include('token')
      expect(response.body).to include('expires_in')
      expect(response.body).to include('refresh_token')
      expect(response.status).to eq(200)
    end

    it 'should return status 401 on bad credentials' do
      post '/api/library_app/v1/users/authenticate', params: { email: 'igor@gmail.com', password: '111' },
           headers: headers
      expect(response.body).to include('Wrong username or password')
      expect(response.status).to eq(401)
    end
  end

  context 'GET /api/library_app/v1/users/me' do
    it 'should return user information' do
      post '/api/library_app/v1/users/authenticate',
           params: { email: user.email, password: user.password }, headers: headers
      body = response.body
      data = JSON.parse body
      user_token = data['token']
      get '/api/library_app/v1/users/me', headers: { 'Authorization' => "Bearer #{user_token}" }
      expect(response.body).to include(user.email)
    end

    it 'should return status 401 \'401 Unauthorized \' on bad user token' do
      get '/api/library_app/v1/users/me', headers: { 'Authorization' => 'Bearer aa11aa11' }
      expect(response.body).to include('401 Unauthorized')
      expect(response.status).to eq(401)
    end
  end
end
