require File.expand_path('../boot', __FILE__)

%w(
  active_model/railtie
  active_record/railtie
  action_controller/railtie
  action_view/railtie
  action_mailer/railtie
  active_job/railtie
  action_cable/engine
  rails/test_unit/railtie
).each do |railtie|
  begin
    require railtie
  rescue LoadError
  end
end

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DoxlyApp
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    #config.assets.precompile << /\.(?:svg|eot|woff|ttf)\z/

    config.generators do |g|
      g.assets false
    end

    # config.assets.precompile += %w( server-bundle.js )
    # config.assets.paths << Rails.root.join("app", "assets", "webpack")

    # type = ENV["REACT_ON_RAILS_ENV"] == "HOT" ? "non_webpack" : "static"

    # config.assets.precompile +=
    #   [
    #     "application_#{type}.js",
    #     "application_#{type}.css"
    #   ]
  end
end
