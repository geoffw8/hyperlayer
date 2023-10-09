class FileBuilder
  def initialize(options = {})
    @options = options

    if options[:url]
      parts = options[:url].split('/')

      if parts.count > 1
        options[:object] = parts.last.singularize
        options[:class] = parts.last.singularize.capitalize
      end
    end
  end

  attr_reader :options

  OPTION_KLASS_MAP = {
    'authorisation' => 'Authorisation',
    'url' => 'ClassDefinition',
    'request' => 'BuildStrongParams',
    'controller_action' => 'ControllerAction',
    'skip-csrf' => 'SkipCsrf'
  }

  def call
    options.to_h.each_with_object(parts) do |(option, _value), output|
      klass = OPTION_KLASS_MAP[option]

      next unless klass

      fragments = "FileBuilder::#{klass}".constantize.call(options: options)

      fragments.each do |part, code|
        output[part] ||= []

        output[part] << code
      end
    end
  end

  private

  def parts
    {
      definition_start: [],
      before_actions: [],
      public_methods: [],
      private_methods: [],
      definition_finish: []
    }
  end

  class Authorisation
    include Callable
    expects :options

    def call
      if options['authorisation'] == '1'
        {
          before_actions: authorisation
        }
      else
        {}
      end
    end

    private

    def authorisation
      template.tap do |temp|
        temp.scan(/\%(.*?)\%/).flatten.uniq.each do |value|
          temp.gsub!("%#{value}%", options[value])
        end
      end
    end

    def template
      File.read('app/views/code/authorisation.erb')[0..-2]
    end
  end

  class ControllerAction
    include Callable
    expects :options

    def call
      if options['controller_action'].present?
        {
          public_methods: code
        }
      else
        {}
      end
    end

    private

    def code
      template.tap do |temp|
        temp.scan(/\%(.*?)\%/).flatten.uniq.each do |value|
          temp.gsub!("%#{value}%", options[value])
        end
      end
    end

    def template
      File.read("app/views/code/controller_actions/#{controller_action}.erb")[0..-2]
    end

    def controller_action
      options['controller_action']
    end
  end

  class TrackEvent
    include Callable
    expects :options

    def call
      if options['track_event'].present?
        {
          before_action: code,
          private_methods: code
        }
      else
        {}
      end
    end

    private

    def code
      template.tap do |temp|
        temp.scan(/\%(.*?)\%/).flatten.uniq.each do |value|
          temp.gsub!("%#{value}%", options[value])
        end
      end
    end

    def template
      File.read("app/views/code/controller_actions/#{controller_action}.erb")[0..-2]
    end

    def controller_action
      options['controller_action']
    end
  end

  class ClassDefinition
    include Callable
    expects :options

    def call
      return {} unless options[:url].present?

      {
        definition_start: start,
        definition_finish: finish
      }
    end

    private

    def start
      levels.map.with_index(1) do |level, index|
        if index == count
          "class #{level.capitalize}Controller < ApplicationController"
        else
          "module #{level.capitalize}"
        end
      end
    end

    def levels
      options[:url].split('/').select(&:present?)
    end

    def count
      levels.count
    end

    def finish
      levels.map { 'end' }
    end
  end

  class SkipCsrf
    include Callable
    expects :options

    def call
      return {} unless options['skip-csrf'] == '1'

      { private_methods: code }
    end

    private

    def code
      template.tap do |temp|
        temp.scan(/\%(.*?)\%/).flatten.uniq.each do |value|
          temp.gsub!("%#{value}%", options[value].to_s)
        end
      end
    end

    def template
      File.read('app/views/code/strong_params.erb')
    end
  end

  class BuildStrongParams
    include Callable
    expects :options

    def call
      return {} unless options[:request].present?

      options[:keys] = keys

      { private_methods: code }
    end

    private

    def code
      template.tap do |temp|
        temp.scan(/\%(.*?)\%/).flatten.uniq.each do |value|
          temp.gsub!("%#{value}%", options[value].to_s)
        end
      end
    end

    def template
      File.read('app/views/code/strong_params.erb')
    end

    def keys
      JSON.parse(options[:request]).keys
    end
  end

  ############################################
  # def parts
  #   {
  #     definition_start: {
  #       def_strong_params: {
  #         open: [],
  #         body: [],
  #         end: []
  #       }
  #     },
  #     before_actions: {},
  #     public_methods: {},
  #     private_methods: {},
  #     definition_finish: {}
  #   }
  # end
  ############################################
end
