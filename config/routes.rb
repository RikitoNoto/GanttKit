Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:index] do
    resources :works, only: [:index]
  end
  root to: "users#index"
end
