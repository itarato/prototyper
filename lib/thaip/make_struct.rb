class MakeStruct
  class CustomStruct
    def initialize(**argkw)
      unknown_keys = argkw.keys - __acceptable_keys
      raise "Unknown ctor keys: #{unknown_keys}" unless unknown_keys.empty?

      __acceptable_keys.each do |key|
        instance_variable_set("@#{key}", argkw.fetch(key, __default_value(key)))
      end
    end

    private

    def __ctor_args
      self
        .class
        .ancestors
        .find { |klass| klass.instance_variables.include?(:@__ctor_args) }
        .instance_variable_get(:@__ctor_args)
    end

    def __acceptable_keys
      keys = __ctor_args[0] + __ctor_args[1].keys
    end

    def __default_value(key)
      __ctor_args[1][key]
    end
  end

  class << self
    def [](*args, **argkw)
      x = argkw
      Class.new(CustomStruct) do
        @__ctor_args = [args, argkw]
        (args + argkw.keys).each(&method(:attr_accessor))
      end
    end    
  end
end
