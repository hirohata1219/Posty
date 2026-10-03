Rails.application.routes.draw do
  namespace :admin do
    get "dashboard/index"
  end
  get "password_resets/new"
  get "password_resets/edit"
  get "profiles/show"
  get "profiles/edit"
  get "up" => "rails/health#show", as: :rails_health_check

  root "posts#index"

  resources :users, only: %i[new create show]

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  resources :posts do
    resources :comments, only: %i[create destroy]
    resource :like, only: %i[create destroy]
    collection do
      get :search
    end
  end

  resource :profile, only: %i[show edit update]

  get "password/reset", to: "password_resets#new", as: :new_password_reset
  post "password/reset", to: "password_resets#create", as: :password_reset
  get "password/reset/edit", to: "password_resets#edit", as: :edit_password_reset
  patch "password/reset", to: "password_resets#update"

  namespace :admin do
    root "dashboard#index"
  end
end
