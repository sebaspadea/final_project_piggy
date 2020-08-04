Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' } 
  root to: 'pages#home'

  get 'user', to: 'users#show'
  get 'expenses/new', to: 'expenses#new'
  post 'expenses', to: 'expenses#create'
  get 'expenses', to: 'expenses#index'
  get 'savings', to: 'savings#index'
  get 'user/edit', to: 'savings#edit'
  patch 'user', to: 'users#update'


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
