source 'https://rubygems.org'
source "https://#{ENV['FURY_AUTH']}@gem.fury.io/g5dev/"

ruby "2.2.2"

gem 'rails', '~> 4.1.11'
gem 'pg'
gem 'sass-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'aws-sdk', '~> 2'
gem 'awesome_print'
gem 'thin'
gem 'httpclient'
gem 'g5_authenticatable'
gem 'rest-client'
gem 'sidekiq'
gem 'sinatra', :require => nil
gem 'whenever', :require => false
gem 'newrelic_rpm'
gem 'redis'
gem 'jquery-rails'
gem 'turbolinks'
gem 'nprogress-rails'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0',          group: :doc
gem 'normalize-rails', '~> 3.0.1'
gem 'bourbon'
gem 'bitters', '~> 1.0.0'
gem 'neat', '~> 1.5.1'
gem 'rails_12factor', group: :production
gem 'actionpack-action_caching'
gem 'resque'
gem 'font-awesome-sass'
gem 'g5_ops'
gem 'pusher'
gem 'sidekiq-failures'

group :development, :test do
  gem 'dotenv-rails'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :test do
  gem 'rspec-sidekiq'
  gem 'webmock', '~> 1.20.3'
  gem "fakeredis", :require => "fakeredis/rspec"
end

group :development do
  gem 'spring'
  gem 'pry'
  gem 'spring-commands-rspec'
  gem 'rack-mini-profiler'
end

