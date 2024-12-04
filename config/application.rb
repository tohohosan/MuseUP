require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MuseUp
  class Application < Rails::Application
    config.hosts << "museup.jp"
    config.load_defaults 7.2
    config.i18n.default_locale = :ja
    config.time_zone = "Tokyo"

    config.autoload_lib(ignore: %w[assets tasks])
    config.active_record.default_timezone = :local
  end
end
