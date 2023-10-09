# frozen_string_literal: true

# BOILERPLATE SERVICE SETUP
#
# I know we are using interactors a lot at the moment but not
# _all_ things are an interactor and there are times where we
# still need to use a good ol' fashion ruby class.
#
# What this _does_ give us however is at least the setup portion
# of an Interactor, simply include this class in a ruby class
# and you'll get:
#
# class SomeClass
#   def self.call(some:, args:, here:)
#     new(some, args, here).call
#   end

#   def inititalize(some, args, here)
#     @some = some
#     @args = args
#     @here = here
#   end

#   def call
#     do some stuff in here
#   end

#   private

#   attr_reader :some, :args, :here
# end

# You can now:

# class SomeClass
#   include Callable

#   expects :some, :args, :here

#   def call
#     do some stuff in here
#   end
# end
#
module Callable # rubocop:disable
  extend ActiveSupport::Concern

  class_methods do
    concerning :ExpectedValues do
      def expects(*keys)
        @expected_keys = keys
      end

      def received_expected_keys(kwargs)
        kwargs.keys.map(&:to_sym) - Array(@optional_keys)
      end

      def validate_expectations_met!(kwargs)
        missing_keys = Array(@expected_keys) - received_expected_keys(kwargs)

        return unless missing_keys.any?

        raise ArgumentError, "Expectations not met - missing keys: #{missing_keys}"
      end
    end

    concerning :OptionalValues do
      def optional(*keys)
        @optional_keys = keys
      end

      def missing_optional_keys(kwargs)
        @optional_keys&.select do |k, _v|
          !kwargs.keys.include?(k)
        end || []
      end

      def missing_optionals(kwargs)
        missing_optional_keys(kwargs).index_with { |_k| nil }
      end
    end

    def readable_attributes(kwargs)
      kwargs.merge(missing_optionals(kwargs))
    end

    def call(kwargs)
      kwargs.deep_symbolize_keys!

      validate_expectations_met!(kwargs)

      new(readable_attributes(kwargs)).call
    end
  end

  # OVERRIDING VALUES IN INITIALIZE
  #
  # If you want to override values in initialize then you can put this in your
  # calling class and it will let you transform one of the values:
  #
  # def initialize(args)
  #   super
  #
  #   @quantity = args[:quantity].to_i
  # end
  #
  # Its not super clean, but there might be times it needs to be done.
  #
  def initialize(kwargs)
    # Set each of them as an instance var, i.e.
    # @something = something
    readable_attributes = self.class.readable_attributes(kwargs)

    readable_attributes.each do |key, value|
      instance_variable_set("@#{key}", value)
    end

    @context = Hashie::Mash.new(kwargs)

    # Then we set them as attr_readers so we can call them
    # i.e. something
    class_eval do
      private

      attr_reader(*readable_attributes.keys.map(&:to_sym))
      attr_reader(:context)
    end
  end
end
