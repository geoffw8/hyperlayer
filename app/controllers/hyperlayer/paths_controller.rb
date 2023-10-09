module Hyperlayer
  class PathsController < ApplicationController
    def index
      # @paths = Path.includes(:events).all.limit(500).order(id: :asc)

      @paths = [
        { id: '1', position: { x: 0, y: 0 }, data: { label: '1' } },
        { id: '2', position: { x: 0, y: 75 }, data: { label: '2' } },
      ]

      render json: @paths.to_json
    end

    def show
      @path = Path.find(params[:id])
    end
  end
end
