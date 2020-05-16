Rails.application.routes.draw do
  resources :works
  # validates :title, presence: true

  resources :users, only: [:index, :create, :show]
	# validates :name, presence: true, uniqueness: true

  resources :votes, only: [:index, :create]

  get '/homepages', to: 'homepages#index', as: 'homepages'
  root to: 'homepages#index'

end
