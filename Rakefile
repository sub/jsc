require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'lib/jsc.rb'

## START Jeweler gem config
begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "jsc"
    gemspec.summary = "Ruby API to Google Closure Compiler Web service"
    gemspec.description = "Ruby API to Google Closure Compiler Web service"
    gemspec.email = "davide.saurino@gmail.com"
    gemspec.homepage = "http://github.com/sub/jsc"
    gemspec.authors = ["Davide Saurino"]
#   gemspec.version = JSCompiler::VERSION

    gemspec.add_dependency 'term-ansicolor', '1.0.4'
  end

  Jeweler::GemcutterTasks.new

rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
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

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "jsc #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

## END Jeweler config
