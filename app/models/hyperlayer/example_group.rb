module Hyperlayer
  class ExampleGroup < ApplicationRecord
    belongs_to :spec
    has_many :events
  end
end
