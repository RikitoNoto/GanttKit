Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }
  resources :users, only: [:index] do
    resources :works, only: [:index, :new]
    resource :user_option, only: [:edit]
  end
  root to: "users#index"
end
