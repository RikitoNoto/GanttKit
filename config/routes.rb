Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }
  resources :users, only: [:index] do
    resources :works, only: [:index]
  end
  root to: "users#index"
end
