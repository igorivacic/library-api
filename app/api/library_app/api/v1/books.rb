class LibraryApp::API::V1::Books < Grape::API
  helpers LibraryApp::API::V1::Assistants::SharedParams
  HEADERS = {
    'Authorization' => {
      description: 'Bearer USERTOKEN',
      required: true
    }
  }
  namespace :books, headers: HEADERS do
    desc 'Create a Book'
    params do
      requires :title, type: String, desc: 'Title'
      requires :number_of_hard_copies, type: String, desc: 'Number of hard copies'
      requires :author_id, type: Integer, desc: 'Author'
    end
    post :new do
      if params['title'] == '' || params['number_of_hard_copies'] == '' || params['author_id'] == ''
        error!('Bad parameters!',
               400)
      end
      book = Book.new(params)
      if book.save!
        status 201
        { data: { book: book.title } }
        # return success message
      else
        error!('Bad parameters!', 400)
      end
    end


  end
end