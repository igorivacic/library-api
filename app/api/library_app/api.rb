module LibraryApp
  class API < Grape::API
    # use ::WineBouncer::OAuth2
    prefix 'library_app'
    mount LibraryApp::API::V1
    # add_swagger_documentation api_version: 'api/v1'
    # add_swagger_documentation mount_path: '/swagger', base_path: 'http://localhost:3000/api', api_version: 'v1'
    # add_swagger_documentation mount_path: '/api-docs', base_path: 'http://localhost:3000/api', api_version: 'v1'
    add_swagger_documentation mount_path: '/swagger', base_path: '/api', api_version: 'v1'
  end
end
