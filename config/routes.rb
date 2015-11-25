Rails.application.routes.draw do
  
  mount G5Authenticatable::Engine => '/g5_auth'
  mount G5Ops::Engine => '/g5_ops'
  require 'resque/server'
  require 'sidekiq/web'
  mount Resque::Server.new, at: "/resque"
  mount Sidekiq::Web => '/sidekiq'

  root 'app_types#index'

  resources :orgs, only: [ :index, :show ]
  resources :app_types, only: [ :index, :show ]
  resources :apps, only: :show do
    get 'live_summary', to: 'live_summaries#index'
  end

  resources :cms, only: [:index]
  resources :real_time_apps
  resources :performance_dashboard, only: [:index]
  resources :admin
  get 'cash', to: 'cash#index', as: "cash"

  resources :cms_deploys

  post 'admin/batch_delete', to: 'admin#batch_delete'
  post 'admin/batch_spin_down', to: 'admin#batch_spin_down'
  post 'admin/batch_config', to: 'admin#batch_config'

end
