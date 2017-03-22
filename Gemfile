source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.0.1'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '5.0.1'

gem 'json-ld', '2.1.0'
gem 'vcard', '0.2.15'

# Parliament Ruby is a wrapper for the internal Parliament data API
gem 'parliament-ruby', '0.5.19'

# Pugin is the front-end component library used by Parliament
gem 'pugin', git: 'https://github.com/ukparliament/parliament.uk-pugin-components-rails', branch: 'master'

# HAML is used for front-end template rendering
gem 'haml', '4.0.7'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # In development and test environments, use the dotenv gem
  gem 'dotenv-rails'

  # Use foreman as a gem in dev and test to orchestrate both the app and api
  gem 'foreman'
  gem 'subcontractor', '0.8.0'

  # Use Rubocop for static code quality analysis
  gem 'rubocop'
end

group :development do
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'web-console'
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

# Gems required for Docker containers
gem 'passenger'
