Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }
  resources :users, only: [:index] do
    resources :works, only: [:index, :new, :create] do
      resources :tasks, only: [:index]
    end
    resource :user_option, only: [:edit]
  end
  root to: "users#index"
end
