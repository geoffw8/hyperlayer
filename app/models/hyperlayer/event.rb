module Hyperlayer
  class Event < ApplicationRecord
    belongs_to :path
    belongs_to :example_group
  
    scope :call, -> { where(event_type: 'call') }
    scope :return, -> { where(event_type: 'return') }
  
    def return_value_events
      Event.where(
        'id > ?', id
      ).find_by(
        event_type: 'return',
        defined_class: defined_class,
        method: method,
        example_group: example_group
      )
    end
  
    def spec
      Hashie::Mash.new(self[:spec])
    end
  
    def method_code
      FindMethodFromEvent.call(self)
    end
  end
end
