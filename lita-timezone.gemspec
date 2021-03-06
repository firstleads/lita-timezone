Gem::Specification.new do |spec|
  spec.name          = 'lita-timezone'
  spec.version       = '0.1.0'
  spec.authors       = ['Thiago von Sydow']
  spec.email         = ['dev@resultadosdigitais.com.br']
  spec.description   = 'Lita handler to convert time between timezones'
  spec.summary       = 'Lita handler to convert time between timezones'
  spec.homepage      = 'https://github.com/ResultadosDigitais/lita-timezone'
  spec.license       = 'MIT'
  spec.metadata      = { 'lita_plugin_type' => 'handler' }

  spec.files         = `git ls-files`.split($RS)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'lita', '~> 4.6'
  spec.add_runtime_dependency 'activesupport', '~> 4.2'
  spec.add_runtime_dependency 'tzinfo', '~> 1.2'

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'rspec', '~> 3.4'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'timecop'
end
