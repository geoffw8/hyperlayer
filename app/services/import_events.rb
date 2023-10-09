# ["#{tp.path}:#{tp.lineno}", tp.defined_class, tp.event, tp.method_id, rv]

require 'csv'

class ImportEvents
  def self.call
    # Connect to a Redis server
    redis = Redis.new(url: 'redis://localhost:6379')

    begin
      # Subscribe to a Redis channel
      redis.subscribe('events') do |on|
        on.message do |channel, message|
          puts "Received message on channel #{channel}: #{message}"

          event = Hashie::Mash.new(JSON.parse(message))

          run = Hyperlayer::Run.where(process: event.spec.process).first_or_create
          path = Hyperlayer::Path.where(path: event.path).first_or_create

          spec_file = event.spec.tree.reverse.first
          spec = run.specs.where(
            location: spec_file.file_path,
            description: spec_file.description, # sometimes a class, could also be a string for a feature spec,
            data: spec_file.except(:file_path, :description)
          ).first_or_create

          example_groups = event.spec.tree.reverse[1..]
          groups = example_groups.map do |example_group|
            spec.example_groups.where(
              location: example_group.location,
              description: example_group.description,
              data: example_group.except(:location, :description)
            ).first_or_create
          end

          example_group = groups.last
          example_group.events.create(
            path: path,
            line_number: event.line_number,
            defined_class: event.defined_class,
            event_type: event.event,
            method: event.method_id,
            return_value: event.return_value,
            arguments: event.arguments,
            variables: event.variables
          )
        end
      end
    rescue Redis::BaseConnectionError => error
      puts "#{error}, retrying in 1s"
      sleep 1
      retry
    end
  end
end
