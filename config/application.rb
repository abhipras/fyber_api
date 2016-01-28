require File.expand_path('../boot', __FILE__)

require 'action_controller/railtie'
require 'active_model/railtie'
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TestApp
  ### Application level configs
  class Application < Rails::Application
    config.autoload_paths << Rails.root.join('lib')
    config.generators do |g|
      g.test_framework :mini_test, spec: true, fixture: false
    end
  end
end
