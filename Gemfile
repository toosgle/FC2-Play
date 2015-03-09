source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.7'

# Use sqlite3 as the database for Active Record
gem 'sqlite3'

### for Google Analytics ###
gem 'google-analytics-rails'

### for JavaScript runtime ###
gem 'therubyracer', :platforms => :ruby

### for session ###
gem 'bcrypt-ruby', '~> 3.1.2'

### for routine work ###
gem 'whenever', :require => false

### for Notification ###
gem 'toastr-rails'

### for database ###
gem 'mysql2', '>= 0.3.12b4'

### adopter from SQLite3 to MySQL
#gem 'yaml_db'

### for scraping
gem 'nokogiri'

### for soft-delete
gem "paranoia", "~> 2.0"

### for fewer string Active Record
gem "squeel"

### for using helper-method in js.erb
gem 'sprockets'

### for bulk insert
gem 'activerecord-import'

group :deployment do
  ### for preloader
  gem 'spring'
  ### for Deploy ###
  #gem 'capistrano', '~> 3.2.1'
  #gem 'capistrano-rails'
  #gem 'capistrano-bundler'
end

group :development, :test do
  ### for test
  # reference http://qiita.com/yusabana/items/8ce54577d959bb085b37
  #gem 'pry-rails'
  #gem 'pry-doc'
  #gem 'pry-stack_explorer'
  #gem 'pry-byebug'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'hirb'
  gem 'hirb-unicode'
  gem 'tapp'
  gem 'awesome_print'

  gem 'rspec'
  gem 'rspec-rails'
  gem 'guard-rails'
  gem 'factory_girl_rails'
  ### for coverage
  gem 'coveralls', :require => false
  gem 'simplecov'
  ### for checking formula of .travis.yml
  gem 'travis-lint'
  ### for encrypt key
  gem 'travis', '~> 1.7.2'
end

group :test do
  ### for rspec one-liner
  gem 'shoulda-matchers'
end

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.1.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
#gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
