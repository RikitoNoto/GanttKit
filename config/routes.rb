Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }
  resources :users, only: [:edit] do
    resources :works, only: [:index] do
      resources :tasks, only: [:index]
    end
    resources :tasks, only: [:show]
  end
  resources :works, only: [:show, :new, :create, :edit, :update, :destroy] do
    resources :tasks, only: [:index, :new, :create, :edit, :update] do#ここのindexはカレンダーフォームのajax用。通常はユーザとワークにネストされたほうを使用する。
      #task#showからplanとprogressを作成する用
      resources :plans, only: [:new]
      resources :progresses, only: [:new]
    end
  end

  resources :tasks, only: [ :destroy]
  resources :plans, only: [:new, :create]
  resources :progresses, only: [:new, :create]
  resources :task_names, only: [:index] do#機械学習用
    resource :task_params, only: [:update]
  end
  root to: "works#index"
end
