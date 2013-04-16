require 'rubygems'
require 'rake'
require 'bundler'

Bundler.setup

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "degrade"
    gem.summary = %Q{Keep track of error rates using redis. Degrade functionality if they're too high.}
    gem.description = %Q{Keep track of error rates using redis. Degrade functionality if they're too high.}
    gem.email = "jamesgolick@gmail.com"
    gem.homepage = "http://github.com/jamesgolick/degrade"
    gem.authors = ["James Golick"]
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "degrade #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
