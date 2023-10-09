class GenerateBuffer < Parser::AST::Processor
  include RuboCop::AST::Traversal
  include Callable
  
  expects :params

  DEFAULT_BUFFER = <<~NODE
    module Fresco
      class Dev
      end
    end
  NODE

  def call
    @code = DEFAULT_BUFFER
    @buffer = RuboCop::ProcessedSource.new(@code, 2.7)

    fields.each do |field|
      @buffer = "#{self.class}::#{field.classify}"
                  .constantize
                  .call(buffer: @buffer, params: params)
    end

    @buffer
  end

  private

  def fields
    params.slice(:url).keys
  end

  class Url
    include Callable
    expects :buffer, :params

    def call
      node = FindMethod.call(
        meth_name: :module,
        source: buffer
      )
  
      Replace.call(
        buffer: code,
        node: node,
        with: InitializeModuleClass.call(url: params[:url])
      )
    end
  end

  class InitializeModuleClass
    include Callable
    expects :url

    def call
      return {} unless url.present?

      [start, finish].flatten.join("\n")
    end

    private

    def start
      levels.map.with_index(1) do |level, index|
        if index == count
          "class #{level.capitalize}Controller < ApplicationController"
        else
          "module #{level.capitalize}"
        end
      end
    end

    def levels
      url.split('/').select(&:present?)
    end

    def count
      levels.count
    end

    def finish
      levels.map { 'end' }
    end
  end

  class FindMethod
    include Callable
    expects :meth_name, :source

    def call
      source.ast
            .each_node
            .map { |n| n if n.type == :send && n.method_name == meth_name }
            .compact
    end
  end

  class Replace
    include Callable
    expects :code, :node, :with

    def call
      code[start...finish] = with
    end

    private

    def start
      node.first.arguments.first.loc.expression.begin_pos
    end

    def finish
      node.first.arguments.first.loc.expression.end_pos
    end
  end
end
