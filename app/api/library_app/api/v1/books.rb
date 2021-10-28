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

    desc 'Get All Books'
    get "",skip_filter: :authenticate do
      status 200
      { data: { book: Book.all } }
    end

    desc 'Get a Book'
    get ':id', skip_filter: :authenticate do
      book = Book.find(params[:id])
      status 200
      { book: { book: book } }
    end

    desc 'Delete a Book'
    delete ':id' do
      book = Book.find(params[:id])
      if book.destroy
        status 200
      else
        status 400
      end
    end

    desc 'Update a Book'
    params do
      requires :title, type: String, desc: 'Title'
      requires :number_of_hard_copies, type: String, desc: 'Number of hard copies'
      requires :author_id, type: Integer, desc: 'Author'
    end
    put ':id/edit' do
      if params['title'] == '' || params['number_of_hard_copies'] == '' || params['author_id'] == ''
        error!('Bad parameters!',
               400)
      end
      book = Book.find(params[:id])
      book.update(title: params[:title], number_of_hard_copies: params[:number_of_hard_copies],
                  author_id: params[:author_id])
      status 201
      { data: { title: book.title } }
    end

    get 'search' do
      term = params[:term]
      sql = "SELECT authors.name, books.title FROM books
             JOIN authors ON books.author_id = authors.id
             WHERE title LIKE '%#{term}%' OR name LIKE '%#{term}%'"
      ActiveRecord::Base.connection.execute(sql)
    end

  end
end
