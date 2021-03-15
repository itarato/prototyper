Gem::Specification.new do |s|
  s.name = 'thaip'
  s.summary = 'Thaip'
  s.version = '0.0.2'
  s.required_ruby_version = '>= 2.6.0'
  s.date = '2021-02-06'
  s.files = Dir.glob('lib/**/*.rb')
  s.require_paths = ['lib']
  s.authors = ['itarato']
  s.email = 'it.arato@gmail.com'
  s.license = 'GPL-3.0-or-later'
  s.homepage = 'https://github.com/itarato/prototyper'
  s.add_development_dependency 'rspec'
end
