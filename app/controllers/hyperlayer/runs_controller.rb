module Hyperlayer
  class RunsController < ApplicationController
    def index
      @runs = Run.all
    end
  end
end
