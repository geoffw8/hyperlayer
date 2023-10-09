# require 'fast'

class UpdateCode < Parser::AST::Processor
  include RuboCop::AST::Traversal

  def self.call(id, code, method)
    new.call(id, code, method)
  end

  LOCATION_MAP = {
    Send: :expression,
    MethodDefinition: :name
  }

  def call(id, code, method)
    path = Path.find(id)
    code = code.presence || File.read(path.path)

    method = method.to_sym

    # First find all instances
    
    source = RuboCop::ProcessedSource.new(code, 2.7)
    nodes = FindMethod.call(
      source: source,
      name: method,
      method_types: [:def, :send]
    )

    nodes.each do |node|
      # Then look again and change them all one by one
      source = RuboCop::ProcessedSource.new(code, 2.7)
      node = FindMethod.call(
        source: source,
        name: method,
        method_types: [:def, :send]
      ).first

      type = node.loc.class.to_s.split("::").last.to_sym

      ReplaceCode.call(
        code: code,
        node: node,
        location: LOCATION_MAP[type],
        with: 'geoff',
      )
    end

    code

    # Add "after/before" which allows to position
    # AddMethod.call(code: code, pos: 150)
  end

  private

  class FindMethod
    include Callable
    expects :source, :name, :method_types

    def call
      source.ast
            .each_node
            .map { |n| n if method_types.include?(n.type) && n.method_name == name }
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

  class ShowCode
    include Callable
    expects :code, :node, :location, :with

    def call
      code[begin_pos...end_pos]
    end

    private

    delegate :begin_pos, :end_pos, to: :expression

    def expression
      node.loc.send(location)
    end
  end

  class ReplaceCode
    include Callable
    expects :code, :node, :location, :with

    def call
      code[begin_pos...end_pos] = with
    end

    private

    delegate :begin_pos, :end_pos, to: :expression

    def expression
      node.loc.send(location)
    end
  end
end
