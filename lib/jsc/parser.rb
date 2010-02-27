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
        if $debug
          puts "#DEBUG flymake parser \n"
        end

        #TODO
        out = ""
        op = JSCompiler.op
        unless result.nil?
          file = JSCompiler.file
          format_type = JSCompiler.format_type

          num = result.size
          result.each do |message|
            out << "#{file}:#{message['lineno']}: #{op.singularize}: #{message['type']}: " + message[op.singularize] +"\n"
            out << "#{file}:#{message['lineno']}: #{op.singularize}: #{message['line']} \n" unless message['line'].nil?
            out << "#{file}:#{message['lineno']}: #{op.singularize}: " + print_under_character(message['charno'])
          end
        else
          out = "No #{op}"
        end
        return out
      end

      def default_parser(result)
        out = ""
        
        if $debug
          puts "#DEBUG default parser \n"
        end

        op = JSCompiler.op
        unless result.nil?
          num = result.size
          out << "You've got #{result.size} #{op}\n"
          i = 0
          result.each do |message|
            i += 1
            out << "\n#{op.singularize.capitalize} n.#{i}\n"
            out << "\t#{message['type']}: " + message[op.singularize] + " at line #{message['lineno']} character #{message['charno']}\n"
            out << "\t" + message['line'] + "\n" unless message['line'].nil?
            out << "\t" + print_under_character(message['charno'])
          end
          out
        else
          "No #{op}"
        end
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
