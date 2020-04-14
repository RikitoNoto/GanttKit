Rails.application.routes.draw do
  devise_for :users
  root to: "works#index"
  resources :users, only: [:index]
end
