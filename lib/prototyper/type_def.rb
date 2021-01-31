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
      a_type === type
    end

    def ===(other)
      is_a?(other)
    end

    def new(*args, **kwargs)
      self_clone = clone
      self_clone.vals = {}

      # TODO: Add typecheck.

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
        
        @vals[key] = args[0]
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
      @vals[@vals.keys[index]] = val
    end

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

TypeDef['Color']
  .with('Black')
  .with('Yellow')
  .with('White')
TypeDef['Bool']
  .with('Yes')
  .with('No')
TypeDef['Address']
  .with('MakeAddress', String, Integer)
TypeDef['BetterAddress']
  .with('MakeBetterAddress', street: String, number: Integer)
TypeDef['Either']
  .with('Left', String)
  .with('Right', Integer)
TypeDef['Optional']
  .with('Nothing')
  .with('Just', BasicObject)

p Black
p Black.type
p White
p White.type
p White.is_a?(Color)
p White.is_a?(Bool)
p Yes.is_a?(Bool)

a = MakeAddress.new("Rene Levesque", 1330)
p a
# a[0] = "fe"
p a[0]

b = MakeBetterAddress.new(street: "Rene Levesque", number: 1330)
p b
# b.number = 12
p b.street
p b.number

err = Left.new("missing")
p err

p Left
p err.value


TypeDef['Foo'].with('MakeFoo', Integer, Integer)

mf = MakeFoo.new(1, "2")
p mf