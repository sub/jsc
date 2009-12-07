require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'lib/google_closure_compiler'
require 'lib/closure_compiler/tasks'

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
  authors  'FIXME (who is writing this software)'
  email  'FIXME (your e-mail)'
  url  'FIXME (project homepage)'
#  version  GoogleClosureCompiler::VERSION
}

