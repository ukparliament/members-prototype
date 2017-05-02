# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'capybara/rails'
require 'vcr'

require 'parliament'
require 'parliament/ntriple'

# Add additional requires below this line. Rails is not loaded until this point!

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!

  # Create a simple matcher which will 'filter' any request URIs on the fly
  config.register_request_matcher :filtered_uri do |request_1, request_2|
    parliament_match = request_1.uri.sub(ENV['PARLIAMENT_BASE_URL'], 'http://localhost:3030') == request_2.uri.sub(ENV['PARLIAMENT_BASE_URL'], 'http://localhost:3030')
    bandiera_match = request_1.uri.sub(ENV['BANDIERA_URL'], 'http://localhost:5000') == request_2.uri.sub(ENV['BANDIERA_URL'], 'http://localhost:5000')

    parliament_match || bandiera_match
  end

  config.default_cassette_options = { match_requests_on: [:method, :filtered_uri] }

  # Dynamically filter our sensitive information
  config.filter_sensitive_data('<AUTH_TOKEN>') { ENV['PARLIAMENT_AUTH_TOKEN'] }
  config.filter_sensitive_data('http://localhost:3030') { ENV['PARLIAMENT_BASE_URL'] }
  config.filter_sensitive_data('http://localhost:5000') { ENV['BANDIERA_URL'] }

  # Dynamically filter n-triple data
  config.before_record do |interaction|
    should_ignore = ['_:node', '^^<http://www.w3.org/2001/XMLSchema#date>', '^^<http://www.w3.org/2001/XMLSchema#integer>']

    # Check if content type header exists and if it includes application/n-triples
    if interaction.response.headers['Content-Type'] && interaction.response.headers['Content-Type'].include?('application/n-triples')
      # Split our data by line
      lines = interaction.response.body.split("\n")

      # How many times have we seen a predicate?
      predicate_occurrances = Hash.new(1)

      # Iterate over each line, decide if we need to filter it.
      lines.each do |line|
        next if should_ignore.any? { |condition| line.include?(condition) }
        next unless line.include?('"')

        # require 'pry'; binding.pry
        # Split on '> <' to get a Subject and Predicate+Object split
        subject, predicate_and_object = line.split('> <')

        # Get the actual object
        predicate, object = predicate_and_object.split('> "')

        # Get the last part of a predicate URI
        predicate_type = predicate.split('/').last

        # Get the number of times we've seen this predicate
        occurrance = predicate_occurrances[predicate_type]
        predicate_occurrances[predicate_type] = predicate_occurrances[predicate_type] + 1

        # Try and build a new object value based on the predicate
        new_object = "#{predicate_type} - #{occurrance}\""

        # Replace the object value
        index = object.index('"')

        object[0..index] = new_object if index

        new_line = "#{subject}> <#{predicate}> \"#{object}"
        config.filter_sensitive_data(new_line) { line }
      end
    end
  end
end

RSpec.configure do |config|

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

end



