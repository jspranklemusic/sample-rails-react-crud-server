require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module Server
  class Application < Rails::Application
    config.load_defaults 7.0
    config.api_only = true
    config.middleware.use ActionDispatch::Cookies
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins 'http://localhost:8000'
        resource '*', 
          :headers => :any, 
          :credentials => true, 
          :methods => [:get, :post, :delete, :put, :options]
      end
    end
  end
end
