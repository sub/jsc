require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'lib/google_closure_compiler.rb'
#require 'lib/google_closure_compiler/tasks'

require 'term/ansicolor'

class Color
  class << self
    include Term::ANSIColor
  end
end

## Mr.Bones config
begin
  require 'bones'
rescue LoadError
  abort '### Please install the "bones" gem ###'
end

ensure_in_path 'lib'
require 'google_closure_compiler'

task :default => 'test:run'
task 'gem:release' => 'test:run'

Bones {
  name  'google_closure_compiler'
  authors  'sub'
  email  'fitzkarraldo@gmail.com'
  url  'http://github.com/sub/google_closure_compiler'
  version  '0.0.1'
  summary 'Google Closure Compiler Ruby REST API'
}

