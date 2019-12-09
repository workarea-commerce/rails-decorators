$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rails/decorators/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rails-decorators"
  s.version     = Rails::Decorators::VERSION
  s.authors     = ["Ben Crouse"]
  s.email       = ["bencrouse@gmail.com"]
  s.homepage    = "https://github.com/weblinc/rails-decorators"
  s.summary     = "Rails::Decorators provides a clean, familiar API for decorating the behavior of a Rails engine."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 6.0.x"

 s.add_development_dependency "sqlite3"
end
