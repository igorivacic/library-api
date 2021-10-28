module LibraryApp::API::V1::Assistants::Authenticate
  extend Grape::API::Helpers

  TOKEN_EXPIRY = 30.days
  REFRESH_TOKEN = true

  def warden
    env['warden']
  end

  def authenticate!
    error!('401 Unauthorized', 401) unless current_user
  end

  def authenticate_librarian!
    error!('401 Unauthorized', 401) unless current_user&.is_librarian
  end

  def current_user
    @current_user ||= authorize_user
  end

  def current_app
    @current_app ||= authenticate_app
  end

  def skip_filter?(name)
    env['api.endpoint'].options[:route_options][:skip_filter]
    filter = env['api.endpoint'].options[:route_options][:skip_filter]
    filter = [filter] unless filter.is_a? Array
    filter.include? name
  end

  def authenticate_app
    @current_app = Doorkeeper::Application.last || Doorkeeper::Application.create(name: 'LibraryApp',
                                                                                  secret: SecureRandom.hex(15), redirect_uri: 'http://www.example.com', scopes: 'library_app')
    error!('Bad client details 2', 403) unless @current_app
    @current_app
  end

  def generate_user_token(user)
    token_attributes = {
      application_id: current_app.id,
      resource_owner_id: user.id,
      scopes: 'library_app',
      expires_in: TOKEN_EXPIRY,
      use_refresh_token: REFRESH_TOKEN
    }
    Doorkeeper::AccessToken.create!(token_attributes)
  end

  def current_user
    @current_user ||= authorize_user
  end

  def authorize_user
    authorization_header = headers['Authorization']
    error!('Bad client details', 403) unless authorization_header
    access_token = authorization_header.gsub(/Bearer /, '')

    doorkeeper_access_token = Doorkeeper::AccessToken.find_by_token(access_token)

    return nil if doorkeeper_access_token.blank?

    return nil if doorkeeper_access_token.expired?
    return nil unless doorkeeper_access_token.scopes.include?('library_app')

    User.find(doorkeeper_access_token.resource_owner_id)
  rescue StandardError => e
    Rails.logger.error('Error in #authorize_user')
    Rails.logger.error(e.message)
    Rails.logger.error(e.backtrace)
    nil
  end
end
