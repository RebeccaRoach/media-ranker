Rails.application.routes.draw do

  get '/login', to: "users#login_form", as: "login"
  post '/login', to: "users#login"
  post '/logout', to: "users#logout", as: "logout"
  
  get '/users/current', to: "users#current", as: "current_user"

  resources :works
  # validates :title, presence: true

  # add create and new to user resources since not doing session controller approach?
  resources :users, only: [:index, :show, :create, :new]
  # validates :name, presence: true, uniqueness: true
 
  # NOT SURE if this is the right path for upvote:
  resources :votes, only: [:new, :create, :destroy]
  get '/upvote', to: 'votes#upvote', as: "upvote"

  get '/homepages', to: 'homepages#index', as: 'homepages'
  root to: 'homepages#index'

end
