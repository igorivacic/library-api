Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users

  mount LibraryApp::API => '/api'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
