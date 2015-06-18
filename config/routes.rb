Rails.application.routes.draw do
  require 'resque/server'
  require 'sidekiq/web'
  mount Resque::Server.new, at: "/resque"
  mount G5Authenticatable::Engine => '/g5_auth'
  mount Sidekiq::Web => '/sidekiq'

  root 'apps#index'

  resources :orgs
  resources :apps
  resources :admin

  post 'admin/batch_delete', to: 'admin#batch_delete'
  post 'admin/batch_spin_down', to: 'admin#batch_spin_down'

end
