Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }
  resources :users, only: [:index] do
    resources :works, only: [:index] do
      resources :tasks, only: [:index]
    end
    resource :user_option, only: [:edit]
  end
  resources :works, only: [:new, :create] do
    resources :tasks, only: [:new, :create]
  end
  root to: "users#index"
end
