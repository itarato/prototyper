class TypeDef
  class DataContainer
    def initialize(name)
      @name = name
      @members = []

      Object.const_set(name, self)
    end

    def to_s
      @name
    end

    def inspect
      @name
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
      @args = nil
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

      @args.zip(args).each do |arg_def, arg|
        self_clone.vals[arg_def] = arg
      end

      @argkw.each do |k, _|
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
        # To support Ruby default behaviour.
        return super(name, *args) unless @vals.key?(name)
  
        @vals[name]
      end
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

b = MakeBetterAddress.new(street: "Rene Levesque", number: 1330)
p b
# b.number = 12
p b.street
p b.number

err = Left.new("missing")
p err

p Left
p err.value