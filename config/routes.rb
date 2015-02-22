Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  root to: 'pages#front'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'
  get 'register', to: 'users#new'
  get 'home', to: 'videos#index'
  get 'my_queue', to: 'queue_items#index'
  get 'people', to: 'relationships#index'

  resources :videos, only: [:show, :index] do
    collection do
      get :search, to: 'videos#search'
    end
    resources :reviews, only: [:create]
  end
  
  resources :categories, only: [:show]
  resources :users, only: [:new, :create, :show]
  resources :queue_items, only: [:create, :destroy] 
  post 'update_queue', to: 'queue_items#update_queue'
  resources :relationships, only: [:create, :destroy]
   
end
