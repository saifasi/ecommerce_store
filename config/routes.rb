Rails.application.routes.draw do
  root 'products#index'

  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :products, only: [:index, :show]
  resources :categories, only: [:show]

  get '/search', to: 'products#search', as: :search

  resource :cart, only: [:show] do
    post   'add/:product_id',    to: 'carts#add',    as: :add_to
    patch  'update/:product_id', to: 'carts#update', as: :update_item
    delete 'remove/:product_id', to: 'carts#remove', as: :remove_item
  end

  resources :orders, only: [:index, :new, :create, :show] do
    post 'pay', on: :member
  end
end

