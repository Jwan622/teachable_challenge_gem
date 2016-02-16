module Configuration
  def configuration
    yield self
  end

  def define_setting(name, default = nil)
    #this sets a class variable
    class_variable_set("@@#{name}", default)

    #this defines a class level setter
    define_class_method("#{name}=") do |value|
      class_variable_set("@@#{name}", value)
    end

    #this defines a class level getter
    define_class_method(name) do
      class_variable_get("@@#{name}")
    end
  end

  private

  # 1. we are opening up the singleton class/metaclass only in order to retrieve "self"
  # 2. next, we are calling instance_eval to define a method on the self which is whatever class we
  # include this module in.
  # 3. The &block, due to the ampersand, refers to the block we pass to the define_class_method method.j
  def define_class_method(name, &block)
    (class << self; self; end).instance_eval do
      define_method name, &block
    end
  end
end
