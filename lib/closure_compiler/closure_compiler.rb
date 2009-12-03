require 'rubygems'  # include RubyGems
gem 'activesupport' # load ActiveSupport
require 'activesupport' # include ActiveSupport
require 'active_support/core_ext/integer/inflections'

require 'json'
require 'net/http'

module ClosureCompiler

# CONFIGURE this with the relative path to your javascript
# folder (typically public/javascripts in a RAILS APP)
JAVASCRIPTS_DIR = "js/"
GOOGLE_SERVICE_ADDRESS = "http://closure-compiler.appspot.com/compile"
DEFAULT_SERVICE = "compiled_code"
DEFAULT_LEVEL = "SIMPLE_OPTIMIZATIONS"

  # this method creates the json hash for the request
  # param: op is the service request
  # error for errors
  # etc
  # default : request for compiled code
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

  def ClosureCompiler.post_to_cc(data)
    post_args = { 
      'js_code' => data["code"],
      'compilation_level' => data["level"],
      'output_format' => data["format"],
      'output_info' => data["info"],
    }
    # send the request
    resp, data = Net::HTTP.post_form(URI.parse(GOOGLE_SERVICE_ADDRESS), post_args)
  end

  def ClosureCompiler.compile(file_name, op, level)
    javascript_code = read_file(file_name)
    level ||= DEFAULT_LEVEL
    resp, data = post_to_cc(create_json_request(javascript_code, op, level))
    parse_json_output(data, op)
  end

  # Parses and returns JSON server response
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
            out = "#{message['type']}: " + message[op.singularize] + " at line #{message['lineno']} character #{message['charno']}"
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

  def ClosureCompiler.read_file(file_name)
    begin
      content = File.open(JAVASCRIPTS_DIR + file_name).read
      return content, true
    rescue
      out = "ERROR reading #{file_name} file"
      return out, false
    end
  end

  # Parses and returns JSON server response
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
