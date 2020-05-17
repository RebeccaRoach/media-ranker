Rails.application.routes.draw do
  resources :works
  # validates :title, presence: true

  resources :users, only: [:index, :show]
  # validates :name, presence: true, uniqueness: true
  
  # will create the user for us
  resources :sessions, only:[:create, :delete]

  resources :votes, only: [:index, :create]

  get '/homepages', to: 'homepages#index', as: 'homepages'
  root to: 'homepages#index'

end
