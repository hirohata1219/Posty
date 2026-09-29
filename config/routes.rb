Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "posts#index"

  resources :users, only: %i[new create show]

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  resources :posts do
    resources :comments, only: %i[create destroy]
    resource :like, only: %i[create destroy]
  end
end
