require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'lib/closure_compiler.rb'

require 'term/ansicolor'

class Color
  class << self
    include Term::ANSIColor
  end
end


# namespace for Closure Compiler API
namespace :cc do

  desc 'Get Compiled Code'
  task :get_compiled_code, :file_name do |t, args|

    puts ClosureCompiler.compile("compiled_code", args.file_name)
  end

  desc 'Check for warnings in the code'
  task :get_warnings, :file_name do |t, args|

    puts ClosureCompiler.compile("warnings", args.file_name)
  end

  desc 'Check for errors in the code'
  task :get_errors, :file_name do |t, args|

    puts ClosureCompiler.compile("errors", args.file_name)
  end

  desc 'Get statistics info for your javascripts code'
  task :get_statistics, :file_name do |t, args|

    unless args.file_name.nil?
      puts ClosureCompiler.compile("statistics", args.file_name)
    else
      puts "No file name parameter => checking the entire directory"
    end
  end

  desc 'Execute every check on the file'
  task :compile, :file_name do |t, args|

    puts ClosureCompiler.compile("compiled_code", args.file_name)
    puts ClosureCompiler.compile("warnings", args.file_name)
    puts ClosureCompiler.compile("errors", args.file_name)
    puts ClosureCompiler.compile("statistics", args.file_name)

  end

#  task :all => [:get_compiled_code, :get_warnings, :get_errors, :get_statistics]

end

