Ruby Thaip
---------------

This is sortof a toolkit to help prototyping things in Ruby.

## Enum maker

Enum-like objects with optional instantiation and value enum types.

```ruby
TypeDef['Color']
  .with('Red')
  .with('Greeen')
  .with('Blue')

color_result = Red
assert(color_result.is_a?(Color))
assert(color_result.is_a?(Red))
assert(Red.is_a?(Color))
assert(Red.is_a?(Red))
refute(Red.is_a?(Yellow))

TypeDef['Discount']
  .with('Percentage', value: Float)
  .with('Bxgy', buy: Integer, get: Integer, value: Float)

b1g1 = Bxgy.new(buy: 1, get: 1, value: 0.25)

# Bxgy.new(buy: 1, get: 1, value: "12") -> raise, value must be Float
```

## Easier structs

```ruby
User = MakeStruct[:name, :age]
user = User.new(name: 'Steve', age: 12)

class Project < MakeStruct[:name, city: 'London']
  def branding
    "#{name} - #{city}"
  end
end

project = Project.new(name: 'Bug-repellent')
puts project.branding

project.city = 'New-London'
```
