Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  root to: 'pages#front'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'
  get 'register', to: 'users#new'
  get 'home', to: 'videos#index'


  resources :videos, only: [:show, :index] do
    collection do
      get :search, to: 'videos#search'
    end
<<<<<<< HEAD

    resources :reviews, only: [:create]
=======
>>>>>>> origin/master
  end
  
  resources :categories, only: [:show]
  resources :users
end
