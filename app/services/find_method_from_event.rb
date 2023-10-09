# require 'fast'

class FindMethodFromEvent < Parser::AST::Processor
  include RuboCop::AST::Traversal

  def self.call(event)
    new.call(event)
  end

  # Have a "Exists?" method that checks to see if something exists
  # If it doesn't use an Insert class and define which section it should go into
  # If it does, work out the differences(?) and update them

  def call(event)
    code = File.readlines(event.path.path).join
    source = RuboCop::ProcessedSource.new(code, 2.7)

    return unless source.present?

    node = FindMethod.call(
      type: :def,
      name: event.method.to_sym,
      source: source
    )

    return unless node.present?

    DisplayMethod
      .call(node: node, code: code)
      .split("\n")
  end

  private

  class FindMethod
    include Callable
    expects :type, :name, :source

    def call
      source.ast
            .each_node
            .map { |n| n if n.type == type && n.method_name == name }
            .compact
    end
  end

  class DisplayMethod
    include Callable
    expects :code, :node

    def call
      code[begin_pos...end_pos]
    end

    private

    delegate :begin_pos, :end_pos, to: :expression

    def expression
      node.first
          .loc
          .expression
    end
  end
end
