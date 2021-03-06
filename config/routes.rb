Rails.application.routes.draw do
  scope module: 'main' do
    root to: 'tasks#index'
    resources :tasks
  end

  namespace :admin do
    resources :sessions
    resources :tasks

    namespace :uploads do
      resources :tasks, only: [:create]
    end
  end
end
