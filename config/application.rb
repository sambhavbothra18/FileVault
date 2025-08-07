require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module YourAppName  # Replace with your actual app name
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`.
    config.autoload_lib(ignore: %w(assets tasks))

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Configure Active Storage to process jobs inline in development
    if Rails.env.development?
      config.active_storage.queues.analysis = nil
      config.active_storage.queues.purge = nil
      config.active_storage.queues.mirror = nil
      
      # Use async adapter for development
      config.active_job.queue_adapter = :async
    else
      # Use sidekiq in production
      config.active_job.queue_adapter = :sidekiq
    end
  end
end