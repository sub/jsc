require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'lib/jsc.rb'
#require 'lib/jsc/tasks'

## Mr.Bones config
begin
  require 'bones'
rescue LoadError
  abort '### Please install the "bones" gem ###'
end

ensure_in_path 'lib'
require 'jsc'

task :default => 'test:run'
task 'gem:release' => 'test:run'

Bones {
  name  'jsc'
  authors  'sub'
  email  'davide.saurino@gmail.com'
  url  'http://github.com/sub/jsc'
  version  JSCompiler::VERSION
  summary 'Simple Ruby API to Google Closure Compiler Web service'
  readme_file 'README.rdoc'
}
