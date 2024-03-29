# frozen_string_literal: true

Rails.application.routes.draw do
  get '/health', to: proc { [200, {}, ['success']] }

  resources :passwords, controller: 'clearance/passwords', only: %i[create new]
  resource :session, controller: 'clearance/sessions', only: [:create]

  resources :users, controller: 'clearance/users', only: [:create] do
    resource :password,
             controller: 'clearance/passwords',
             only: %i[edit update]
  end

  get '/sign_in' => 'clearance/sessions#new', as: 'sign_in'
  delete '/sign_out' => 'clearance/sessions#destroy', as: 'sign_out'
  get '/sign_up' => 'clearance/users#new', as: 'sign_up'

  mount Sidekiq::Web => '/sidekiq'
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  root 'home#index'
  resources :gages, except: [:show]
  resource :reports, only: %i[new create]

  post '/csp_violations', to: 'csp_violations#create'
end
