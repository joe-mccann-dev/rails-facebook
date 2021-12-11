Rails.application.routes.draw do
  root to: 'posts#index'
  get 'profile', to: 'users#show'

  devise_for :users
  resources :users, only: [:index, :show] do
    resource :profile
  end
  resources :posts, only: [:index, :create, :show] do
    resources :likes, only: [:create]
    resources :comments
  end

  resources :comments do
    resources :comments
    resources :likes, only: [:create]
  end
  
  resources :notifications, only: [:index, :update]
  resources :friendships, only: [:create, :update]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
