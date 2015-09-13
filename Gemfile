source 'https://rubygems.org'
source "https://#{ENV['FURY_AUTH']}@gem.fury.io/g5dev/"

ruby "2.2.2"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.1.11'

# Use sqlite3 as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby
gem 'thin'

gem 'httpclient'
gem 'g5_authenticatable'
gem 'rest-client'
gem 'sidekiq'
gem 'sinatra', :require => nil
gem 'whenever', :require => false
gem 'newrelic_rpm'
# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Turbolinks-friendly loading indicators
gem 'nprogress-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

#Front End
gem 'normalize-rails', '~> 3.0.1'
gem 'bourbon'
gem 'bitters', '~> 1.0.0'
gem 'neat', '~> 1.5.1'

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
end

group :development do
  gem 'spring'
  gem 'pry'
  gem 'spring-commands-rspec'
  gem 'rack-mini-profiler'
end

gem 'rails_12factor', group: :production

gem 'actionpack-action_caching'

gem 'resque'

gem 'font-awesome-sass'
gem 'g5_ops'
