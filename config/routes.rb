Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }
  resources :users, only: [:edit] do
    resources :works, only: [:index] do
      resources :tasks, only: [:index]
    end
    resources :tasks, only: [:show]
  end
  resources :works, only: [:show, :new, :create, :edit, :update, :destroy] do
    resources :tasks, only: [:index, :new, :create, :edit, :update]#ここのindexはカレンダーフォームのajax用。通常はユーザとワークにネストされたほうを使用する。
  end

  resources :tasks, only: [ :destroy]
  resources :plans, only: [:new, :create]
  resources :progresses, only: [:new, :create]
  root to: "works#index"
end
