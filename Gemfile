source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.0.2'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '5.0.1'

gem 'json-ld', '2.1.2'
gem 'vcard', '0.2.15'

# Parliament Ruby is a wrapper for the internal Parliament data API
gem 'parliament-ruby', '~> 0.7.6'

# Parliament NTriple processes N-triple data
gem 'parliament-ntriple', '~> 0.1.1', require: false

# Parliament Grom Decorators decorates Grom nodes
gem 'parliament-grom-decorators', '~> 0.1.2'

# Pugin is the front-end component library used by Parliament
gem 'pugin', '0.6.0'

# HAML is used for front-end template rendering
gem 'haml', '4.0.7'

# Include time zone information
gem 'tzinfo-data'

# Use Puma as our web server
gem 'puma'
gem 'rack-timeout'

# Client for Bandiera feature flagging
gem 'bandiera-client'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # In development and test environments, use the dotenv gem
  gem 'dotenv-rails'

  # Use foreman as a gem in dev and test to orchestrate both the app and api
  gem 'foreman'
  gem 'subcontractor'

  # Use Rubocop for static code quality analysis
  gem 'rubocop'
end

group :development do
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'web-console'

  gem 'pry'
end

group :test do
  gem 'capybara'
  gem 'rails-controller-testing'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'webmock'
  gem 'vcr'
end
