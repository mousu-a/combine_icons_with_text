Rails.application.routes.draw do
  root "home#welcome"
  get 'welcome', to: 'home#welcome'
  get 'terms', to: 'home#terms'
  get 'privacy', to: 'home#privacy'
  resources :icons, only: %i[index new create destroy]
  resources :users, only: :destroy
  resources :admin, only: :index
  namespace :admin do
    resources :icon_change_links, only: :create
    resources :overlay_texts, only: :create
  end
  get 'auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: 'sessions#auth_failure'
  delete 'logout', to: 'sessions#destroy', as: 'logout'

  get "up" => "rails/health#show", as: :rails_health_check
end
