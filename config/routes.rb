Rails.application.routes.draw do

  mount G5Authenticatable::Engine => '/g5_auth'
  require 'resque/server'
  require 'sidekiq/web'
  mount Resque::Server.new, at: "/resque"
  mount Sidekiq::Web => '/sidekiq'

  root 'apps#index'

  resources :orgs, only: [ :index, :show ]
  resources :apps

end
