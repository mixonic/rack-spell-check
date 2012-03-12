Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.rubygems_version = '1.3.5'

  s.name              = 'rack-spell-check'
  s.version           = '0.0.1'
  s.date              = '2012-03-11'

  s.summary     = "Rack::SpellCheck - Spell check your HTML pages with Aspell, Nokogiri, and Rack."
  s.description = "A Ruby Rack & Rails middleware using Aspell & Nokogiri to check for misspellings."

  s.authors  = ["Matthew Beale"]
  s.email    = 'matt.beale@madhatted.com'
  s.homepage = 'http://github.com/mixonic/rack-spell-check'

  s.require_paths = %w[lib]

  s.executables = []

  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = %w[]

  s.add_dependency('rack')
  s.add_dependency('raspell')
  s.add_dependency('logger')
  s.add_dependency('nokogiri')

  s.add_development_dependency('rake', "~> 0.9")
  s.add_development_dependency('rdoc', "~> 3.11")
  s.add_development_dependency('mocha')
  
  # = MANIFEST =
  s.files = %w[
    Gemfile
    LICENSE
    README.md
    Rakefile
    TODO
    lib/rack-spell-check.rb
    lib/rack/spell_check/middleware.rb
    lib/rack/spell_check/railtie.rb
    lib/rack/spell_check/version.rb
    rack-spell-check.gemspec
    test/rack/spell_check/.middleware_test.rb.swp
    test/rack/spell_check/middleware_test.rb
    test/test_helper.rb
  ]
  # = MANIFEST =

  s.test_files = s.files.select { |path| path =~ /^test\// }
end
