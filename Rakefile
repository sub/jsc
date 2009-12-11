require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'lib/jsc.rb'
#require 'lib/jsc/tasks'

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
require 'jsc'

task :default => 'test:run'
task 'gem:release' => 'test:run'

Bones {
  name  'jsc'
  authors  'sub'
  email  'fitzkarraldo@gmail.com'
  url  'http://github.com/sub/jsc'
  version  '0.0.1'
  summary 'Google Closure Compiler Ruby REST API'
}

