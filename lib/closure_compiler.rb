require 'json'
require 'net/http'
require 'active_support/core_ext/integer/inflections'

module ClosureCompiler

# CONFIGURE this with the relative path to your javascript
# folder (typically public/javascripts in a RAILS APP)
JAVASCRIPTS_DIR = "js/"
  
  def ClosureCompiler.call_service(op, file_name)
    javascript_code = read_code(file_name)
    parameters = {
    	"code" => javascript_code,
#	"level" => "WHITESPACE_ONLY",
	"level" => "SIMPLE_OPTIMIZATIONS",
	"format"   => "json",
	"info"  => op
	}
    response = post_to_cc(parameters)
  end

  def ClosureCompiler.compile(op, file_name)
    response = call_service(op, file_name)
    parse_json_output(response, op)
  end

  def ClosureCompiler.post_to_cc(data)
    # get the url that we need to post to  
    url = URI.parse('http://closure-compiler.appspot.com/compile')  
    # build the params string
    post_args = { 
      'js_code' => data["code"],
      'compilation_level' => data["level"],
      'output_format' => data["format"],
      'output_info' => data["info"],
    }
    # send the request  
    resp, data = Net::HTTP.post_form(url, post_args)
    data
  end

  def ClosureCompiler.read_code(filename)
    begin
      content = ""
      file = File.open(JAVASCRIPTS_DIR + filename)
      file.each {|line| content = content + line }
      #content = file.gets
      file.close
      content
    rescue
      out = "ERROR opening #{filename} file"
    end
  end

  # Parses and returns JSON server response
  def ClosureCompiler.parse_json_output(response, op)
    parsed_response = JSON.parse(response, :max_nesting => false)
    case op
    when "compiled_code"
      out = parsed_response['compiledCode']
    when "statistics"
      result = parsed_response['statistics']
      size_improvement = result['originalSize'] - result['compressedSize']
      out =  "You'd got a size improvement of #{size_improvement} in #{result['compileTime']} msec"
    when "serverErrors"
      result = parsed_response['serverErrors']
      out = "Server Error: #{result['error']} - Error Code: #{result['code']}"
    else
      #case for errors or warnings
      begin
        result = parsed_response[op]
        unless result.nil?
          result.each do |message|
            out = "#{message['type']}: " + message[op.singularize] + " at line #{message['lineno']} character #{message['charno']}"
            out += message['line']
            return out
          end
        else
          return "No #{op} found"
        end
      rescue
        out = "Error parsing JSON output...Check your output"
      end    
    end
  end

end
