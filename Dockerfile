# Use an official Ruby runtime as a parent image
FROM ruby:3.2.0

# Install necessary packages
RUN apt-get update && \
    apt-get install -qq -y --no-install-recommends \
        build-essential \
        protobuf-compiler \
        nodejs \
        vim \
        postgresql-client && \
    rm -rf /var/lib/apt/lists/*

# Install gems
RUN gem install bundler && \
    gem install rails && \
    gem install protobuf

# Set the working directory to /app
WORKDIR /app

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install app dependencies
RUN bundle install

# Copy the app code
COPY . .

# Expose port 3000 for the Rails app to run on
EXPOSE 3000

# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]