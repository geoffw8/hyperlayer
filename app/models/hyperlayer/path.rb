module Hyperlayer
  class Path < ApplicationRecord
    has_many :events

    before_create :set_spec
  
    def set_spec
      return unless path.include?('spec')
  
      self.spec = true
    end
  
    def overlay
      BuildFileOverlay.call(path: self)
    end
  
    def test_one
      TestOne.call(path: self)
    end
  
    def edited
      Ast.call(id)
    end
  
    def overlay_code
      @code = ''
  
      events.where(event_type: 'return').each do |event|
        @code = UpdateCode.call(id, @code, event.method)
      end
  
      @code
    end
  end
end
