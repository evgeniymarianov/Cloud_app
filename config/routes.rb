# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users
  resources :articles
  get 'welcome/main'
  namespace :admin do
    root 'welcome#index'
  end
  resources :users
  resource :login, only: %i[show create destroy]
  resources :orders do
    member do
      get 'approve'
    end
    member do
      get 'calc'
    end
    collection do
      get 'first'
    end
    collection do
      get 'check'
    end
  end

  mount GrapeApi => '/api'
  mount GrapeSwaggerRails::Engine => '/swagger'
  mount Sidekiq::Web => '/sidekiq'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
