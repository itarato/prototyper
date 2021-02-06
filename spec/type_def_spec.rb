require_relative '../lib/thaip'

describe TypeDef do
  describe 'flame test' do
    it 'works with enum like classes' do
      TypeDef['Color']
        .with('Red')
        .with('Yellow')
        .with('Green')

      expect(Red.is_a?(Color)).to(eq(true))
      expect(Yellow.is_a?(Color)).to(eq(true))
      expect(Green.is_a?(Color)).to(eq(true))

      expect(Yellow.is_a?(Integer)).to(eq(false))

      expect(Red.type).to(eq(Color))
      expect(Yellow.type).to(eq(Color))
      expect(Green.type).to(eq(Color))

      red = Red.new
      expect(red.type).to(eq(Color))
      expect(red.is_a?(Red)).to(eq(true))
      expect(red.is_a?(Yellow)).to_not(eq(true))

      red2 = Red.new
      expect(red).to_not(eq(red2))
      expect(red === red2).to(eq(true))
    end

    it 'works as struct enums' do
      TypeDef['User']
        .with('Employee', String, String, Integer)
        .with('Security', company: String, level: Integer)

      empty_employee = Employee.new

      expect(empty_employee[0]).to(eq(nil))
      expect(empty_employee[1]).to(eq(nil))
      expect(empty_employee[2]).to(eq(nil))

      employee = Employee.new("Steve", "London", 123)
      expect(employee[0]).to(eq('Steve'))
      expect(employee[1]).to(eq('London'))
      expect(employee[2]).to(eq(123))

      expect { Employee.new(123) }.to(raise_error(RuntimeError)) 

      sec = Security.new(company: "IBM", level: 2)
      expect(sec.company).to(eq('IBM'))
      expect(sec.level).to(eq(2))

      sec.company = 'Motorola'
      expect(sec.company).to(eq('Motorola'))

      expect { sec.company = 1 }.to(raise_error(RuntimeError)) 
    end
  end
end
