module Hyperlayer
  class Engine < ::Rails::Engine
    isolate_namespace Hyperlayer

    initializer "hyperlayer.use_parent_app_database" do
      database_config = Rails.configuration.database_configuration[Rails.env]
      ActiveRecord::Base.establish_connection(database_config)
    end

    initializer "hyperlayer.load_migrations" do |app|
      unless app.root.to_s.match?(config.root.to_s)
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end

    initializer "hyperlayer.assets.precompile" do |app|
      app.config.assets.precompile += %w( hyperlayer/application.css hyperlayer/app.css hyperlayer/prism.css hyperlayer/prism.js hyperlayer/application.js )
    end
  end
end
