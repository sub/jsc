require 'rubygems'  # include RubyGems
gem 'activesupport' # load ActiveSupport
require 'activesupport' # include ActiveSupport
require 'active_support/core_ext/integer/inflections'

require 'json'
require 'net/http'

module ClosureCompiler

# CONFIGURE this with the relative path to your javascript
# folder (typically public/javascripts in a RAILS APP)
# NO MORE NEEDED
#JAVASCRIPTS_DIR = "js/"

# Link to Google Closure Compiler service
GOOGLE_SERVICE_ADDRESS = "http://closure-compiler.appspot.com/compile"
# Default output_info parameter
DEFAULT_SERVICE = "compiled_code"
# Default compilation_level parameter
DEFAULT_LEVEL = "SIMPLE_OPTIMIZATIONS"

  # Create the <em>JSON</em> hash for the request and return the hash to send along with the request
  #
  # Accepted parameters:
  # * <b>code</b>: json_code parameter
  # * <b>op</b>: output_info parameter
  # * <b>level</b>: compilation_level parameter
  def ClosureCompiler.create_json_request(code, op = nil, level = nil)
    op ||= DEFAULT_SERVICE
    level ||= DEFAULT_LEVEL
    parameters = {
    	"code" => code,
	"level" => level,
	"format"   => "json",
	"info"  => op
	}
  end

  # Send the JSON request hash to Google service and return its response
  #
  # Accepted paramters:
  # * <b>data</b>: the json hash
  def ClosureCompiler.post_to_cc(data)
    post_args = { 
      'js_code' => data["code"],
      'compilation_level' => data["level"],
      'output_format' => data["format"],
      'output_info' => data["info"]
    }
    # send the request
    resp, data = Net::HTTP.post_form(URI.parse(GOOGLE_SERVICE_ADDRESS), post_args)
  end

  # Read a file and call compile method
  #
  # Accepted parameters:
  # * <b>file_name</b>: the absolute path to the file
  # * <b>op</b>: output_info parameter
  # * <b>level</b>: compilation_level parameter
  def ClosureCompiler.compile_file(file_name, op, level = DEFAULT_LEVEL)
#    javascript_code = read_file(JAVASCRIPTS_DIR + file_name)
    javascript_code = read_file(file_name)
    compile(javascript_code, op, level)
#    resp, data = post_to_cc(create_json_request(javascript_code, op, level))
#    parse_json_output(data, op)
  end

  # Compile code and return parsed output
  #
  # Accepted parameters:
  # * <b>javascript_code</b>: the code to compile
  # * <b>op</b>: output_info parameter
  # * <b>level</b>: compilation_level parameter
  def ClosureCompiler.compile(javascript_code, op, level = DEFAULT_LEVEL)
    resp, data = post_to_cc(create_json_request(javascript_code, op, level))
    parse_json_output(data, op)
  end

  # Call compile method for every file in a dir
  #
  # Accepted parameters:
  # * <b>dir</b>: the directory
  # * <b>op</b>: output_info parameter
  # * <b>level</b>: compilation_level parameter
  def ClosureCompiler.compile_dir(dir, op, level = DEFAULT_LEVEL)
    out = String.new
    Dir.entries(dir).each do |file|
      if File.extname(file) == ".js"
        out << "Statistics for file #{file}...\n"
        out << compile_file(file, op, level) + "\n***************\n"
      end
    end
    return out
  end

  # Parse and return JSON server response
  #
  # Accepted parameters:
  # * <b>response</b>: the server response
  # * <b>op</b>: output_info parameter
  def ClosureCompiler.parse_json_output(response, op)
    out = String.new
    parsed_response = JSON.parse(response, :max_nesting => false)
#p response

    if parsed_response.has_key?("serverErrors") 
      result = parsed_response['serverErrors']
      return "Server Error: #{result[0]['error']} - Error Code: #{result[0]['code']}"
    end

    case op
    when "compiled_code"
      out = parsed_response['compiledCode']
    when "statistics"
      result = parsed_response['statistics']
      out = create_statistics_output(result)
    else "errors"
      #case for errors or warnings
      begin
        result = parsed_response[op]
        unless result.nil?
          result.each do |message|
            out = "#{message['type']}: " + message[op.singularize] + " at line #{message['lineno']} character #{message['charno']}\n"
            out << message['line'] unless message['line'].nil?
            return out
          end
        else
          return "No #{op}"
        end
      rescue
        out = "Error parsing JSON output...Check your output"
      end
    end
  end

  # Read file and return its content
  #
  # Accepted parameters:
  # * <b>file_name</b>: the absolute path to the file
  def ClosureCompiler.read_file(file_name)
    begin
#      content = File.open(JAVASCRIPTS_DIR + file_name).read
      content = File.open(file_name).read
      return content, true
    rescue
      out = "ERROR reading #{file_name} file"
      return out, false
    end
  end

  # Parses and returns JSON server response
  #
  # Accepted parameters:
  # * <b>result</b>: the already parsed JSON server response
  def ClosureCompiler.create_statistics_output(result)
    size_improvement = result['originalSize'] - result['compressedSize']
    size_gzip_improvement = result['originalGzipSize'] - result['compressedGzipSize']
    rate_improvement = (size_improvement * 100)/result['originalSize']
    rate_gzip_improvement = (size_gzip_improvement * 100)/result['originalGzipSize']
    out = "Original Size: #{result['originalSize']} bytes (#{result['originalGzipSize']} bytes gzipped) \n"
    out << "Compiled Size: #{result['compressedSize']} bytes (#{result['compressedGzipSize']} bytes gzipped) \n"
    out << "\t Saved #{rate_improvement}% off the original size (#{rate_gzip_improvement}% off the gzipped size)"
  end

end
