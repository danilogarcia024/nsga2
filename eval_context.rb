require "yaml"

class EvalContext
  def initialize(*modules)
    modules.to_a.each do |mod|
      extend mod
    end
  end

  def load_variables(filepath)
    config = ::YAML.load_file(filepath)
    config.each do |method_name, return_value|
      self.class.send(:define_method, method_name, -> { return_value })
    end
  end
end
