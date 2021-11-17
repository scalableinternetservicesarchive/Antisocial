Rails.application.routes.draw do



  devise_for :users, :path_prefix => 'd'
  resources :users, :only =>[:show]

  root 'home#index'
  # get 'home/index'
  # get 'users/index'

  match '/users',   to: 'users#index',   via: 'get'
  match '/users/profile',     to: 'users#show',       via: 'get'


  # Resources
  resources :posts do
    resources :comments
  end

  resources :friendships

  resources :users do
    member do
      get :posts
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
