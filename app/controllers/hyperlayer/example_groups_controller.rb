module Hyperlayer
  class ExampleGroupsController < ApplicationController
    def index
      @run = Hyperlayer::Run.find(params[:run_id])
      @spec = @run.specs.find(params[:spec_id])
      @example_groups = @spec.example_groups
    end
  end
end
