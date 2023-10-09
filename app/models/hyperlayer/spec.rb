module Hyperlayer
  class Spec < ApplicationRecord
    belongs_to :run
  
    has_many :example_groups
    has_many :events
  end
end
