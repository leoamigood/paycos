# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  # Defines the root path route ("/")
  root to: redirect('/api-docs')

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :accounts, only: :create do
        resources :payment_methods, only: %i[index create]
        resources :payments, only: %i[create show]
        resources :balance, only: %i[index]
      end
    end
  end
end
