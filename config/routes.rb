Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }
  resources :users, only: [:index] do
    resources :works, only: [:index] do
      resources :tasks, only: [:index]
    end
    resource :user_option, only: [:edit]
  end
  resources :works, only: [:new, :create] do
    resources :tasks, only: [:index, :new, :create]#ここのindexはカレンダーフォームのajax用。通常はユーザとワークにネストされたほうを使用する。
  end

  resources :plans, only: [:new, :create]
  resources :progresses, only: [:new, :create]
  root to: "works#index"
end
