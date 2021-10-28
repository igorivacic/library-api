module LibraryApp::API::V1::Assistants::DataParser
  extend Grape::API::Helpers

  def parse_data(data)
    case data
    when String
      JSON.parse(data)
    when Hash
      data
    else
      error!('Unsuported data type', 400)
    end
  end
end
