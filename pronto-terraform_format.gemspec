# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pronto/terraform_format/version'

Gem::Specification.new do |spec|
  spec.name          = 'pronto-terraform_format'
  spec.version       = Pronto::TerraformFormat::VERSION
  spec.authors       = ['Kazunori Kojima']
  spec.email         = ['kjm.kznr@gmail.com']

  spec.summary       = 'Pronto runner for Terraform'
  spec.description   = <<-EOF
    A pronto runner for Terraform.
  EOF
  spec.homepage      = 'https://github.com/kjmkznr/pronto-terraform_format'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'pronto', '~> 0.9.0'
  spec.add_dependency 'unified_diff', '~> 0.3.6'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 11.0'
  spec.add_development_dependency 'rspec', '~> 3.7'
  spec.add_development_dependency 'rspec-its', '~> 1.2'
end

