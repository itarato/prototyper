Gem::Specification.new do |s|
  s.name = 'prototyper'
  s.summary = 'Prototyper'
  s.version = '0.0.1'
  s.required_ruby_version = '>= 2.6.0'
  s.date = '2021-02-01'
  s.files = Dir.glob('lib/**/*.rb')
  s.require_paths = ['lib']
  s.authors = ['itarato']
  s.email = 'it.arato@gmail.com'
  s.license = 'GPL-3.0-or-later'
  # s.homepage = 'https://github.com/itarato/???'
  # s.add_runtime_dependency 'parser', '~> 2.7', '>= 2.7.1'
  s.add_development_dependency 'rspec'
end
