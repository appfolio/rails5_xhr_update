# frozen_string_literal: true

require_relative 'lib/rails5_xhr_update/version'

Gem::Specification.new do |s|
  s.author = 'Bryce Boe'
  s.description = <<~DESCRIPTION
    rails5_xhr_update is a program that can be used to help convert from the
    ``xhr :get, :action`` test syntax used in rails prior to Rails 5, to the
    Rails 5 syntax: ``get :action, xhr: true``.
  DESCRIPTION
  s.email = 'bryce.boe@appfolio.com'
  s.executables = %w[rails5_xhr_update]
  s.files = Dir.glob('{bin,lib}/**/*') + %w[CHANGES.md LICENSE.txt README.md]
  s.homepage = 'https://github.com/appfolio/rails5_xhr_update'
  s.license = 'BSD-2-Clause'
  s.name = 'rails5_xhr_update'
  s.summary = 'Update Rails 4 xhr test method calls to rails 5 syntax.'
  s.version = Rails5XHRUpdate::VERSION

  s.add_runtime_dependency 'unparser', '~> 0.2'
end
