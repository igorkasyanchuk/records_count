$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "records_count/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "records_count"
  s.version     = RecordsCount::VERSION
  s.authors     = ["Igor Kasyanchuk"]
  s.email       = ["igorkasyanchuk@gmail.com"]
  s.homepage    = "https://github.com/igorkasyanchuk"
  s.summary     = "Find out how many records you receives"
  s.description = "See in Rails console how many records your query returns. It can help with solving performance issues."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails"
  s.add_dependency "colorize"

  s.add_development_dependency "sqlite3"
end
