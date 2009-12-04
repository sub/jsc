
require File.join(File.dirname(__FILE__), %w[spec_helper])

describe GoogleClosureCompiler do

   describe 'Use the web service through API' do
    
    describe 'Put all keys in the request' do

      before do
        code = "function hello(a){alert(\"Hello, \"+a)}hello(\"New user\");"
        @request = ClosureCompiler.create_json_request(code)
      end

      it 'should create a request with code key' do
        @request['code'].should_not be_nil
      end

      it 'should create a request with level key' do
        @request['level'].should_not be_nil
      end

      it 'should create a request with format key' do
        @request['format'].should_not be_nil
      end

      it 'should create a request with info key' do
        @request['info'].should_not be_nil
      end

      it 'should create a JSON request with all requested keys' do
        ["code","level","format","info"].each { |key| @request[key.intern].should }
      end
    end

    describe 'send a request for compilation level' do
      before do
        @code = "function hello(a){alert(\"Hello, \"+a)}hello(\"New user\");"
      end

      it 'should send a WHITESPACE_ONLY request' do
        request = ClosureCompiler.create_json_request(@code, "errors", "WHITESPACE_ONLY")
        request['level'].should == 'WHITESPACE_ONLY'
      end
    
      it 'should send an ADVANCED_OPTIMIZATIONS request' do
        request = ClosureCompiler.create_json_request(@code, "errors", "ADVANCED_OPTIMIZATIONS")
        request['level'].should == 'ADVANCED_OPTIMIZATIONS'
      end
    end
    
    describe 'create a JSON compile-code request (default request)' do
      before do
        code = "function hello(a){alert(\"Hello, \"+a)}hello(\"New user\");"
        @request = ClosureCompiler.create_json_request(code)
      end

      it 'with the right value for level key' do
        @request['level'].should == 'SIMPLE_OPTIMIZATIONS'
      end

      it 'with the right value for format key' do
        @request['format'].should == 'json'
      end

      it 'with the right value for info key' do
        @request['info'].should == 'compiled_code'
      end
      
      it 'with the right param for code key' do
        @request['code'].should_not be_nil
      end
    end

    describe 'send a JSON compile-code request' do
      before do
        code = "function hello(a){alert(\"Hello, \"+a)}hello(\"New user\");"
        @request = ClosureCompiler.create_json_request(code)
      end

      it 'should receive a right server response' do
        resp, data = ClosureCompiler.post_to_cc(@request)
        resp.kind_of?(Net::HTTPOK).should be_true
      end
        
      it 'should receive the compiled code' do
        resp, data = ClosureCompiler.post_to_cc(@request)
        code = ClosureCompiler.parse_json_output(data, "compiled_code")
        code.should_not be_nil
      end
    end


    describe 'send a JSON error request' do
      before do
        code = "functiont hello(a){alert(\"Hello, \"+a)}hello(\"New user\");"
        @request = ClosureCompiler.create_json_request(code, "errors")
        @resp, @data = ClosureCompiler.post_to_cc(@request)
#puts @data
      end

      it 'should receive an HTTPOK response' do
        @resp.kind_of?(Net::HTTPOK).should be_true
      end
      
     it 'should receive the error field' do
        @data['errors'].should_not be_nil
     end

     it 'should return the result string' do
        result = ClosureCompiler.parse_json_output(@data, "errors")
        result.should =~ /at line/
     end
    end

    describe 'send a JSON warning request' do
      before do
        code = "function hello(a){return; alert(\"Hello, \"+a)}hello(\"New user\");"
        @request = ClosureCompiler.create_json_request(code, "warnings")
        @resp, @data = ClosureCompiler.post_to_cc(@request)
      end

      it 'should receive an HTTPOK response' do
        @resp.kind_of?(Net::HTTPOK).should be_true
      end

      it 'should receive the warning field' do
        @data['warnings'].should_not be_nil
      end

      it 'should return the result string' do
        result = ClosureCompiler.parse_json_output(@data, "warnings")
        result.should =~ /at line/
      end
      
    end

    describe 'send a JSON statistics request' do
      before do
        code = "function hello(a){alert(\"Hello, \"+a)}hello(\"New user\");"
        @request = ClosureCompiler.create_json_request(code, "statistics")
        @resp, @data = ClosureCompiler.post_to_cc(@request)
      end

      it 'should receive an HTTPOK response' do
        @resp.kind_of?(Net::HTTPOK).should be_true
      end
      
      it 'should receive the statistics field' do
        @data['statistics'].should_not be_nil
      end

      it 'should return the result string' do
        result = ClosureCompiler.parse_json_output(@data, "statistics")
        result.should =~ /Original Size:/
      end
    end
  end

  describe 'read .js file' do
    before do
      #test file
      @file_name = 'test.js'
    end

    it 'should return the code without errors' do
      result, value = ClosureCompiler.read_file(@file_name)
      value.should be_true
    end
  end

  describe 'compile a whole directory' do

    it 'should get statistics for every file' do
      js_dir = "js"
      result = ClosureCompiler.compile_dir(js_dir, "statistics")
      # suppose I have 2 files in the dir
      2.times do 
        result.should =~ /Original Size:/
      end
    end
  end

end
