class TypeDef
  class DataContainer
    def initialize(name)
      @name = name
      @members = []

      Object.const_set(name, self)
    end

    def to_s
      "<#{@name}>"
    end

    def inspect
      to_s
    end

    def with(name, *args, **argkw)
      DataConstructor.new(name, self, *args, **argkw)
      self
    end
  end

  class DataConstructor
    attr_accessor :vals

    def initialize(name, data_container, *args, **argkw)
      @name = name
      @data_container = data_container
      @vals = {}
      @args = args
      @argkw = argkw

      Object.const_set(name, self)
    end

    def to_s
      "<#{@name}#{@vals.map { |k, v| " #{k}:#{v}"}.join}>"
    end
    alias_method :inspect, :to_s

    def type
      @data_container
    end

    def is_a?(a_type)
      if a_type.respond_to?(:__class) && a_type.__class == DataConstructor
        return self.class == a_type.class
      end

      a_type === type
    end

    def ===(other)
      return is_a?(other) if other.is_a?(DataContainer)
      
      is_a?(other.type)
    end

    def new(*args, **kwargs)
      self_clone = clone
      self_clone.vals = {}

      @args.zip(args).each_with_index do |(type, arg), index|
        raise "Expected type <#{type}> for value <#{arg}>" unless arg.nil? || arg.is_a?(type)

        key = "#{type}-#{index}"
        self_clone.vals[key] = arg
      end

      @argkw.each do |k, type|
        raise "Expected type <#{type}> for value <#{kwargs[k]}>" unless kwargs[k].nil? || kwargs[k].is_a?(type)

        self_clone.vals[k] = kwargs[k]
      end

      self_clone
    end

    def value
      @vals.values[0]
    end

    def defined?(name)
      return true if @vals.key?(name)
      super(name)
    end

    def method_missing(name, *args)
      if name.to_s.end_with?('=')
        key = name.to_s[0..-2].to_sym
        return super(name, *args) unless @vals.key?(key)
        
        type = @argkw[key]
        value = args[0]
        raise "Expected type <#{type}> for value <#{value}>" unless value.nil? || value.is_a?(type)

        @vals[key] = value
      else
        return super(name, *args) unless @vals.key?(name)
  
        @vals[name]
      end
    end

    def [](index)
      raise "Index out of bounds" if index >= @vals.size
      @vals.values[index]
    end

    def []=(index, val)
      raise "Index out of bounds" if index >= @vals.size

      # TODO add typecheck
      @vals[@vals.keys[index]] = val
    end

    alias_method :__class, :class
    def class
      @name
    end
  end

  def self.data(name)
    DataContainer.new(name)
  end

  class << self
    def [](name)
      DataContainer.new(name)
    end
  end
end
