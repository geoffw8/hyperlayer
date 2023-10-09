# require 'fast'

class FindMethodInPath < Parser::AST::Processor
  include RuboCop::AST::Traversal

  def self.call(path_id)
    new.call(path_id)
  end

  # Have a "Exists?" method that checks to see if something exists
  # If it doesn't use an Insert class and define which section it should go into
  # If it does, work out the differences(?) and update them

  def call(path_id)
    path = Path.find(path_id)
    code = File.readlines(path.path).join
    source = RuboCop::ProcessedSource.new(code, 2.7)

    path.events.call.each_with_object({}) do |event, methods|
      methods[event.method.to_sym] = ''

      node = FindMethod.call(
        type: :def,
        name: event.method.to_sym,
        source: source
      )

      next unless node.present?

      methods[event.method.to_sym] = DisplayMethod.call(node: node, code: code)
    end
  end

  private

  class FindMethod
    include Callable
    expects :type, :name, :source

    def call
      binding.pry

      source.ast
            .each_node
            .map { |n| n if n.type == type && n.method_name == name }
            .compact
    end
  end

  class AddMethod
    include Callable
    expects :code, :pos

    def call
      code.insert(pos, "def code \n inserted.here! \n end")
    end
  end

  class Replace
    include Callable
    expects :code, :node, :with

    def call
      code[begin_pos...end_pos] = with
    end

    private

    delegate :begin_pos, :end_pos, to: :expression

    def expression
      node.first
          .arguments
          .first
          .loc
          .expression
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
