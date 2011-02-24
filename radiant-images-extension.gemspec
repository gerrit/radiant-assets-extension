# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "radiant-images-extension/version"

Gem::Specification.new do |s|
  s.name        = "radiant-images-extension"
  s.version     = RadiantImagesExtension::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Gerrit Kaiser"]
  s.email       = ["gerrit@gerritkaiser.de"]
  s.homepage    = "http://yourwebsite.com/images"
  s.summary     = %q{Images for Radiant CMS}
  s.description = %q{Makes Radiant better by adding images!}
  
  s.add_dependency 'dragonfly', '~>0.8.2'
  s.add_dependency 'aws-s3', '~>0.6.2'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.post_install_message = %{
  Add this to your radiant project with:
    config.gem 'radiant-images-extension', :version => '#{RadiantImagesExtension::VERSION}'
  }
end