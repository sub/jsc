module JSCompiler
  module Parser

    class << self

      # this methos calls the right parser for result
      def parse(result)
        return flymake_parser(result) if JSCompiler.format_type == "flymake"
        default_parser(result)
      end
      
      # window_message_handlers.js:73: strict warning: trailing comma is not legal in ECMA-262 object initializers:
      def flymake_parser(result)
        puts "#DEBUG flymake parser \n" if $debug

        errors = false
        op = JSCompiler.op
        unless result.nil?
          file = JSCompiler.file
          format_type = JSCompiler.format_type
          result.each do |message|
            out << "#{file}:#{message['lineno']}: #{op.singularize}: #{message['type']}: " + message[op.singularize] +"\n"
            out << "#{file}:#{message['lineno']}: #{op.singularize}: #{message['line']} \n" unless message['line'].nil?
            out << "#{file}:#{message['lineno']}: #{op.singularize}: " + print_under_character(message['charno'])
          end
          errors = true
        else
          out = "No #{op}"
        end
        puts out if errors
        errors
      end

      def default_parser(result)     
        puts "#DEBUG default parser \n" if $debug

        out = ""
        errors = false
        op = JSCompiler.op
        unless result.nil?
          out << "You've got #{result.size} #{op}\n"
          i = 0
          result.each do |message|
            i += 1
            out << "\n#{op.singularize.capitalize} n.#{i}\n"
            out << "\t#{message['type']}: " + message[op.singularize] + " at line #{message['lineno']} character #{message['charno']}\n"
            out << "\t" + message['line'] + "\n" unless message['line'].nil?
            out << "\t" + print_under_character(message['charno'])
          end
          errors = true
        else
          "No #{op}"
        end
        puts out if errors
        errors
      end

      def print_under_character(pos)
        i = 0
        auto_fill = ""
        while i < pos -1
          auto_fill << "."
          i = i+1
        end
        auto_fill << " ^ \n"
      end

    end
  end
end
