class LibraryApp::API::V1::Base < Grape::API
  helpers LibraryApp::API::V1::Assistants::SharedParams

  namespace :users do
    desc 'User Authentication', headers: {
      'Authorization' => {
        description: 'Bearer APPTOKEN',
        required: true
      }
    }

    params do
      requires :email, type: String, documentation: { param_type: 'body' }
      requires :password, type: String, documentation: { param_type: 'body' }
    end

    post 'authenticate', skip_filter: :authenticate do
      user = User.find_for_authentication(email: params[:email])
      if user&.valid_password?(params[:password])
        access_token = generate_user_token(user)
        status 200
        {
          token: access_token.token,
          expires_in: access_token.expires_in,
          refresh_token: access_token.refresh_token
        }
      else
        error!('Wrong username or password', 401)
      end
    end

    desc 'User Profile Information', headers: {
      'Authorization' => {
        description: 'Bearer USERTOKEN',
        required: true
      }
    }
    get 'me', skip_filter: :authenticate_librarian do
      {
        email: @current_user.email
      }
    end
  end
end
