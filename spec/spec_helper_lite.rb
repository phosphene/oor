def stub_module(full_name, &block) 
  stub_class_or_module(full_name, Module)
end

def stub_class(full_name, &block) 
  stub_class_or_module(full_name, Class)
end

def stub_class_or_module(full_name, kind, &block)
  full_name.to_s.split(/::/).inject(Object) do |context, name|
    begin
      # First try to autoload the class or module
      context.const_get(name) 
    rescue NameError
      # Overload const_missing
      mod = Module.new do
        define_method(:const_missing) do |missing_constant_name|
          if missing_constant_name.to_s == name.to_s
            value = kind.new
            const_set(name, value)
            value
          else
            super(missing_const_name)
          end
        end
      end
      context.extend(mod)
    end
  end 
end

require 'rr'
class MiniTest::Unit::TestCase
  include RR::Adapters::MiniTest
end
