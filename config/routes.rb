Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root to: 'pages#home'

  get 'user', to: 'users#show'
  get 'expenses/new', to: 'expenses#new'
  post 'expenses', to: 'expenses#create'
  # get 'expenses/edit', to: 'expenses#edit'
  patch 'expense/:id', to: 'expenses#update', as: :expense
  get 'expenses', to: 'expenses#index'
  get 'savings', to: 'savings#index'
  get 'savings/new', to: 'savings#new', as: :new_saving
  post 'savings', to: 'savings#create'
  get 'savings/edit', to: 'savings#edit'
  patch 'savings', to: 'savings#update'
  patch "savings/break", to: "savings#break_chanchito", as: :break_chanchito
  get 'user/edit', to: 'users#edit'
  patch 'user', to: 'users#update'
  post "create_bank", to: "expenses#create_bank"
  get "sync_bank_account", to: "expenses#sync_bank_account", as: :synk_bank
  
  require "sidekiq/web"
  authenticate :user, lambda { |u| u.present? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
