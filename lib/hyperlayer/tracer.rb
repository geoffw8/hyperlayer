# lib/hyperlayer/tracer.rb

module Hyperlayer
  module Tracer
    def self.trace_rspec!
      trace = setup_trace
      trace.enable
      
      RSpec.configure do |config|
        config.after(:suite) { trace.disable }
      end
    end

    private

    def self.setup_trace
      TracePoint.new(:call, :return) do |tp|
        next unless relevant_path?(tp.path)

        event_data = extract_event_data(tp)

        Redis.new(url: 'redis://localhost:6379').publish('events', event_data.to_json)
      end
    end

    def self.relevant_path?(path)
      path.include?('tembo')
    end

    def self.extract_event_data(tp)
      args = MethodTracer.arguments_for(tp)
    
      event = {
        path: tp.path,
        line_number: tp.lineno,
        defined_class: tp.defined_class.to_s,
        event: tp.event,
        method_id: tp.method_id,
        arguments: args,
        return_value: (tp.event == :return ? tp.return_value.to_s : nil)
      }
    
      # RSpec metadata extraction (as per your original code)
      if defined?(RSpec) && RSpec.respond_to?(:current_example) && RSpec.current_example
        metadata = Hashie::Mash.new(RSpec.current_example.metadata)
    
        tree = []
        tree << metadata.except(:example_group, :block)
        tree << metadata.example_group.except(:parent_example_group, :block)
    
        parent = metadata.example_group.parent_example_group
    
        while parent
          tree << parent.except(:parent_example_group, :block)
          parent = parent.parent_example_group
        end
    
        tree.each do |branch|
          branch['described_class'] = branch['described_class'].to_s
          branch['description_args'] = [branch['description_args'].first.to_s]
    
          if branch['execution_result']
            branch['execution_result'] = branch['execution_result'].started_at.to_f
          end
        end
    
        event[:spec] = {
          process: Process.pid,
          run: metadata.execution_result.started_at.to_f.to_s,
          tree: tree
        }
      end
    
      event[:return_value] = nil if event[:return_value]&.class != String
      event
    end
  end
end
