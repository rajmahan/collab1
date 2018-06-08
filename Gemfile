if RUBY_PLATFORM =~ /java/
  ruby "2.3.3", :engine => 'jruby', :engine_version => '9.1.16.0'
else
  ruby "2.3.5"
end


source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.8'

unless RUBY_PLATFORM == "java"
  gem 'pg', '0.17.1'
  # Thinking Sphinx requires this though we don't use mysql
  gem 'mysql2'
else
  gem 'jdbc-mysql', '~> 5.1', '>= 5.1.35', :platform => :jruby
  gem 'jdbc-postgres', '~> 9.4', '>= 9.4.1206'
  gem 'activerecord-jdbcpostgresql-adapter', '~> 1.3', '>= 1.3.9'
  # This is going to remove after getting proper fix for
  # Serialization of AR objects broken - TypeError: Java type is not serializable .
  # https://github.com/jruby/activerecord-jdbc-adapter/commit/352b7d092f343e1110e2ece6b6e4b87ff7db0542
  gem 'activerecord-jdbc-adapter'
  gem 'jruby-openssl', '~> 0.9.21'
end

gem 'bootstrap-sass', '~> 3.3.6'

# Use jdbcpostgresql as the database for Active Record
#gem 'activerecord-jdbcpostgresql-adapter'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyrhino'
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'devise'

group :development, :test do
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
