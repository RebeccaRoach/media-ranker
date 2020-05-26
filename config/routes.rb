Rails.application.routes.draw do

  get '/login', to: "users#login_form", as: "login"
  post '/login', to: "users#login"
  post '/logout', to: "users#logout", as: "logout"

  resources :works
  post '/works/:id/upvote', to: 'works#upvote', as: "upvote"

  resources :users, only: [:index, :show, :new]

  get '/homepages', to: 'homepages#index', as: 'homepages'
  root to: 'homepages#index'

end
