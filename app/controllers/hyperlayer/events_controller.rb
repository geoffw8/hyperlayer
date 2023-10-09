module Hyperlayer
  class EventsController < ApplicationController
    APP_DIR = Rails.root.to_s.split('/').last

    def index
      @spec = Spec.find(params[:spec_id])
      
      @example_group = @spec.example_groups.find(params[:example_group_id])
      
      @events = @example_group.events
                              .call
                              .includes(:path)
                              .where(path: { spec: nil })
                              .order(id: :asc)
                              .select { |e| e.path.path.include?(APP_DIR) }

      @groups = []
      used_ids = []

      @events.each.with_index do |event, index|
        next if used_ids.flatten.include?(event.id)

        batch = { event.defined_class => [] }

        count = index

        while true do
          next_event = @events[count]

          break if next_event.nil? || next_event.defined_class != event.defined_class

          batch[event.defined_class] << @events[count]

          count += 1
        end

        @groups << batch
        used_ids << batch.values.flatten.map(&:id)
        used_ids.flatten
      end

      # first_klass = @groups.first.keys.first
      # first_event = @groups.first.values.first.first

      # @tree = [
      #   {
      #     klass: first_klass,
      #     method: first_event.method,
      #     return_value_id: first_event.return_value_events&.id,
      #     children: []
      #   }
      # ]

      # @groups.each do |group|
      #   klass = group.keys.first
      #   events = group.values.first

      #   events.each do |event|
      #     while event.id < @tree.last[:return_value_id]
      #       {
      #         klass: klass,
      #         method: event.method,
      #         return_value_id: event.return_value_events&.id,
      #         children: []
      #       }
      #     end
      #   end
      # end

      @tree = BuildTree.call(@events)
    end
  end

  class BuildTree
    def self.call(events, used_ids = [])
      branches = []
      current_branch = nil
  
      events.each.with_index do |event, index|
        if !used_ids.include?(event.id)
          rest_of_events = events[(index + 1)..-1].select { |e| e.id < event.return_value_events&.id }
          used_ids << event.id
  
          current_branch = {
            event => BuildTree.call(rest_of_events, used_ids)
          }
  
          branches.push(current_branch)
        end
      end
  
      branches
    end
  end
end
