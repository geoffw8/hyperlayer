# require 'fast'

class SplitMethods < Parser::AST::Processor
  include RuboCop::AST::Traversal

  def self.call(event)
    new.call(event)
  end

  def call(event)
    raw_code = File.readlines(event.path.path)
    code = raw_code.join
    source = RuboCop::ProcessedSource.new(code, 3.2)

    method_name = event.method.to_sym

    method = source.ast
                    .each_node
                    .select do |n|
                      # Will need to add method name here, and the delegate param
                      #
                      n.type == :def && method_name == n.method_name # || n.type == :send && n.method_name == :delegate
                    end

    method = method.first

    DisplayMethod.call(code: code, node: method)
  rescue => e
    Rails.logger.info("Missing method: #{method_name}")
  end

  private

  class DisplayMethod
    include Callable
    expects :code, :node

    def call
      code[begin_pos...end_pos]
    end

    private

    delegate :begin_pos, :end_pos, to: :expression

    def expression
      node.loc.expression
    end
  end
end
