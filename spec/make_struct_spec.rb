require_relative '../lib/thaip'

describe MakeStruct do
  describe 'flame test' do
    it 'works' do
      class Foo1 < MakeStruct[:name, age: 12]; end

      f = Foo1.new
      expect(f.name).to(eq(nil))
      expect(f.age).to(eq(12))
    end

    it 'works with no new class' do
      Foo2 = MakeStruct[:name, age: 12]

      f = Foo2.new
      expect(f.name).to(eq(nil))
      expect(f.age).to(eq(12))
    end

    it 'works with multiple parent class' do
      class Bar < MakeStruct[:name, age: 12]; end
      class Foo3 < Bar; end

      f = Foo3.new
      expect(f.name).to(eq(nil))
      expect(f.age).to(eq(12))
    end

    it 'works with multiple instances' do
      class Foo4 < MakeStruct[:name, age: 12]; end
      class Foo5 < MakeStruct[:city, age: 21]; end

      foo4 = Foo4.new
      foo5 = Foo5.new

      expect(foo4.name).to(eq(nil))
      expect(foo4.age).to(eq(12))

      expect(foo5.city).to(eq(nil))
      expect(foo5.age).to(eq(21))
    end

    it 'works with proc default values' do
      class Foo6 < MakeStruct[vals: -> { [] }]; end

      i1 = Foo6.new
      i2 = Foo6.new

      i1.vals << 1
      i2.vals << 2

      expect(i1.vals).to(eq([1]))
      expect(i2.vals).to(eq([2]))
    end
  end
end
