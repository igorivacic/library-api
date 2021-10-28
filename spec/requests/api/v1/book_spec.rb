require 'rails_helper'
RSpec.describe LibraryApp::API::V1::Books, type: :request do
  let(:user) { create(:user) }
  let(:headers) do
    app_header = { 'Authorization' => "Bearer #{create(:doorkeeper_app).secret}" }
    post '/api/library_app/v1/users/authenticate', params: { email: user.email, password: user.password },
                                                   headers: app_header
    body = response.body
    data = JSON.parse body
    { 'Authorization' => "Bearer #{data['token']}" }
  end

  context 'POST Errors /api/library_app/v1/books/new' do
    it 'should return error on no headers present' do
      post '/api/library_app/v1/books/new'
      expect(response.body).to include('Bad client details')
      expect(response.status).to eq(403)
    end

    # it 'should return error on no body present' do
    #   post '/api/library_app/v1/books/new', headers: headers
    #   expect(response.body).to include("title is missing")
    #   expect(response.status).to eq(500)
    #   expect(response.message).to include("Internal Server Error")
    # end
  end
end
