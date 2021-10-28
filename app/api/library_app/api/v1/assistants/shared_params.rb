module LibraryApp::API::V1::Assistants::SharedParams
  extend Grape::API::Helpers

  params :pagination do
    optional :page, type: Integer, default: 1
    optional :per_page, type: Integer, default: 20
  end

  params :sort do
    optional :sort_field, type: String
    optional :sort_order, type: String, values: %w[asc desc]
  end
end
