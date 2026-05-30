Rails.application.routes.draw do
  # TODO　後で消す　啓発用
  # root "home#welcome"
  root "icons#new"
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
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
