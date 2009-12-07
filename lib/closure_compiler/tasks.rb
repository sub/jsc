# namespace for Closure Compiler API
namespace :cc do

  desc 'Get Compiled Code'
  task :get_compiled_code, :file_name do |t, args|

    puts ClosureCompiler.compile_file(args.file_name, "compiled_code")
  end

  desc 'Check for warnings in the code'
  task :get_warnings, :file_name do |t, args|

    puts ClosureCompiler.compile_file(args.file_name, "warnings")
  end

  desc 'Check for errors in the code'
  task :get_errors, :file_name do |t, args|

    puts ClosureCompiler.compile_file(args.file_name, "errors")
  end

  desc 'Get statistics info for your javascripts code'
  task :get_statistics, :file_name do |t, args|

    unless args.file_name.nil?
      puts ClosureCompiler.compile_file(args.file_name, "statistics")
    else
      puts "No file name parameter => checking the entire directory"
    end
  end

  desc 'Execute every check on the file'
  task :compile, :file_name do |t, args|

    puts ClosureCompiler.compile_file(args.file_name, "compiled_code")
    puts "*******************"
    puts ClosureCompiler.compile_file(args.file_name, "warnings")
    puts "*******************"
    puts ClosureCompiler.compile_file(args.file_name, "errors")
    puts "*******************"
    puts ClosureCompiler.compile_file(args.file_name, "statistics")
  end

  desc 'Get statistics info for every file in a directory'
  task :compile_dir, :dir_name do |t, args|

    puts ClosureCompiler.compile_dir(args.dir_name, "statistics")
  end

#  task :all => [:get_compiled_code, :get_warnings, :get_errors, :get_statistics]

end
