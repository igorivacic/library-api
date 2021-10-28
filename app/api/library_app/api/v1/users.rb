class LibraryApp::API::V1::Users < Grape::API
  helpers LibraryApp::API::V1::Assistants::SharedParams
  HEADERS = {
    'Authorization' => {
      description: 'Bearer USERTOKEN',
      required: true
    }
  }
  namespace :users, headers: HEADERS do
    desc 'History of loan'
    get ':id/loans' do
      user = User.find(params[:id])
      user.loans
    end
  end
end
