require_relative "boot"
require "rails/all"
Bundler.require(*Rails.groups)

module BlogApi
  class Application < Rails::Application
    config.load_defaults 7.0
    config.api_only = true
    config.active_job.queue_adapter = :sidekiq
  end
end
