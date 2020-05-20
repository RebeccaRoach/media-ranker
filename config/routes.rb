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
 
  # will create the user
  # resources :sessions, only:[:create, :delete]

  resources :votes, only: [:index, :create]

  get '/homepages', to: 'homepages#index', as: 'homepages'
  root to: 'homepages#index'

end
