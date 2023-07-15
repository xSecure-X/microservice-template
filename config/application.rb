require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module UserService
  class Application < Rails::Application
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins 'http://localhost:4200'
        resource '/api/v1/*', headers: :any, methods: [:get, :post, :put, :patch, :delete, :options]
      end
    end
  end
end
