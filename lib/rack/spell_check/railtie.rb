module Rack::SpellCheck
  class Railtie < Rails::Railtie
    initializer "rack-spell-check.insert_middleware" do |app|
      app.config.middleware.use "Rack::SpellCheck::Middleware"
    end
  end
end
