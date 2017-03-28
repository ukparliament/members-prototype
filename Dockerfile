FROM ruby:2.3.1-alpine

# Add command line argument variables used to cusomise the image at build-time.
ARG PARLIAMENT_BASE_URL
ARG GTM_KEY
ARG ASSET_LOCATION_URL
ARG SECRET_KEY_BASE
ARG RACK_ENV=production

# Add Gemfiles.
ADD Gemfile /app/
ADD Gemfile.lock /app/

# Set the working DIR.
WORKDIR /app

# Install system and application dependencies.
RUN apk --update add --virtual build-dependencies build-base ruby-dev && \
    gem install bundler --no-ri --no-rdoc && \
    echo "Environment (RACK_ENV): $RACK_ENV" && \
    if [ "$RACK_ENV" == "production" ]; then \
      bundle install --without development test --path vendor/bundle; \
    else \
      bundle install --path vendor/bundle; \
    fi && \
    apk del build-dependencies

# Copy the application onto our image.
ADD . /app

# Make sure our user owns the application directory.
RUN chown -R nobody:nogroup /app

# Set up our user and environment
USER nobody
ENV PARLIAMENT_BASE_URL $PARLIAMENT_BASE_URL
ENV GTM_KEY $GTM_KEY
ENV ASSET_LOCATION_URL $ASSET_LOCATION_URL
ENV SECRET_KEY_BASE $SECRET_KEY_BASE
ENV RACK_ENV $RACK_ENV
ENV RAILS_SERVE_STATIC_FILES true

# Precompile assets
RUN rails assets:precompile

# Add additional labels to our image
ARG GIT_SHA=unknown
ARG GIT_TAG=unknown
LABEL git-sha=$GIT_SHA \
	    git-tag=$GIT_TAG \
	    rack-env=$RACK_ENV \
	    maintainer=mattrayner1@gmail.com

# Launch puma
CMD ["bundle", "exec", "rails", "s", "Puma"]
