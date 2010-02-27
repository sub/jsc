require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'lib/jsc.rb'
#require 'lib/jsc/tasks'

## START Jeweler gem config
begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "jsc"
    gemspec.summary = "Ruby API to Google Closure Compiler Web service"
#    gemspec.description = ""
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

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "jsc #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

## END Jeweler config

## START Mr.Bones config
# begin
#   require 'bones'
# rescue LoadError
#   abort '### Please install the "bones" gem ###'
# end

# ensure_in_path 'lib'
# require 'jsc'

# task :default => 'test:run'
# task 'gem:release' => 'test:run'

# Bones {
#   name  'jsc'
#   authors  'sub'
#   email  'davide.saurino@gmail.com'
#   url  'http://github.com/sub/jsc'
#   version  JSCompiler::VERSION
#   summary 'Ruby API to Google Closure Compiler Web service'
#   readme_file 'README.rdoc'
# }

## END Mr.Bones config
