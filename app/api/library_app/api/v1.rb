class LibraryApp::API::V1 < Grape::API
  version 'v1', using: :path, vendor: 'LibraryApp'
  content_type :json, 'application/json; charset=UTF-8'
  format :json

  before do
    header['Access-Control-Allow-Origin'] = '*'
    header['Access-Control-Request-Method'] = '*'
    authenticate! unless skip_filter?(:authenticate)
    authenticate_librarian! unless skip_filter?(:authenticate_librarian) || skip_filter?(:authenticate)
  end

  rescue_from :all do |e|
    Rails.logger.error('ERROR!!!!!')
    Rails.logger.error(e.message)
    if Rails.env.development?
      puts e.backtrace
    else
      Rails.logger.error(e.backtrace)
    end
    Rack::Response.new([{ 'error' => e.message + '|' + e.class.to_s }.to_json], 500,
                       { 'Content-type' => 'application/json' }).finish
  end

  helpers LibraryApp::API::V1::Assistants::Authenticate

  mount Base
  mount Books
end
