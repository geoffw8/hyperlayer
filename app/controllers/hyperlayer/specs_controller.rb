module Hyperlayer
  class SpecsController < ApplicationController
    def index
      @run = Run.find(params[:run_id])
      @specs = @run.specs
    end
  end
end
