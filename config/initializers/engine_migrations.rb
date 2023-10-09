Hyperlayer::Engine.config.paths['db/migrate'].expanded.each do |expanded_path|
  Rails.application.config.paths['db/migrate'] << expanded_path
end
