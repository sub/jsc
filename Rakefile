require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'lib/google_closure_compiler'

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

    puts ClosureCompiler.compile(args.file_name, "compiled_code")
  end

  desc 'Check for warnings in the code'
  task :get_warnings, :file_name do |t, args|

    puts ClosureCompiler.compile(args.file_name, "warnings")
  end

  desc 'Check for errors in the code'
  task :get_errors, :file_name do |t, args|

    puts ClosureCompiler.compile(args.file_name, "errors")
  end

  desc 'Get statistics info for your javascripts code'
  task :get_statistics, :file_name do |t, args|

    unless args.file_name.nil?
      puts ClosureCompiler.compile(args.file_name, "statistics")
    else
      puts "No file name parameter => checking the entire directory"
    end
  end

  desc 'Execute every check on the file'
  task :compile, :file_name do |t, args|

    puts ClosureCompiler.compile(args.file_name, "compiled_code")
    puts "*******************"
    puts ClosureCompiler.compile(args.file_name, "warnings")
    puts "*******************"
    puts ClosureCompiler.compile(args.file_name, "errors")
    puts "*******************"
    puts ClosureCompiler.compile(args.file_name, "statistics")
  end

#  task :all => [:get_compiled_code, :get_warnings, :get_errors, :get_statistics]

end

