# lib/hyperlayer/method_tracer.rb

class MethodTracer
  def self.arguments_for(tp)
    method_params = tp.self.method(tp.method_id).parameters
    method_params.map do |type, name|
      [name, tp.binding.local_variable_get(name)]
    end.to_h
  rescue => e
    {} # Return an empty hash in case of errors
  end
end
