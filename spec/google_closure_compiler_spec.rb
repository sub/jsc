
require File.join(File.dirname(__FILE__), %w[spec_helper])

describe GoogleClosureCompiler do

   describe 'Use the web service through API' do
    
    describe 'Put all keys in the request' do

      before do
        code = "function hello(a){alert(\"Hello, \"+a)}hello(\"New user\");"
        @request = ClosureCompiler.create_json_request(code)
        @request['level'] = "SIMPLE_OPTIMIZATIONS"
        @request['info'] = "compiled_code"
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

    describe 'create a JSON compile-code request (default request)' do
      before do
        code = "function hello(a){alert(\"Hello, \"+a)}hello(\"New user\");"
        @request = ClosureCompiler.create_json_request(code)
        @request['level'] = "SIMPLE_OPTIMIZATIONS"
        @request['info'] = "compiled_code"
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

    describe 'compile code and get compiled code' do
      before do
        code = "function hello(a){alert(\"Hello, \"+a)}hello(\"New user\");"
        @resp = ClosureCompiler.compile(code, "compiled_code", "SIMPLE_OPTIMIZATIONS")
      end
 
      it 'should receive the compiled code' do
        @resp.should_not be_nil
      end
    end
    
    describe 'compile code and find errors' do
      before do
        code = "functiont hello(a){alert(\"Hello, \"+a)}hello(\"New user\");"
        @resp = ClosureCompiler.compile(code, "errors", "SIMPLE_OPTIMIZATIONS")
      end
      
      it 'should return the result string' do
        @resp.should match(/at line/)
      end
    end
    
    describe 'compile code and find warnings' do
      before do
        code = "function hello(a){return; alert(\"Hello, \"+a)}hello(\"New user\");"
        @resp = ClosureCompiler.compile(code, "warnings", "SIMPLE_OPTIMIZATIONS")
      end
      
      it 'should return the result string' do
        @resp.should match(/at line/)
      end  
    end
 
    describe 'compile code and obtain statistics' do
      before do
        code = "function hello(a){alert(\"Hello, \"+a)}hello(\"New user\");"
        @resp = ClosureCompiler.compile(code, "statistics", "SIMPLE_OPTIMIZATIONS")
      end
  
      it 'should return the result string' do
        @resp.should match(/Original Size:/)
      end
    end
  end
  
  describe 'read .js file' do
    before do
      #test file
      @file_name = 'js/compiled_code.js'
    end

    it 'should return the code without errors' do
      result, value = ClosureCompiler.read_file(@file_name)
      value.should be_true
    end
  end

  describe 'compile a whole directory' do

    it 'should get statistics for every file' do
      js_dir = "js"
      result = ClosureCompiler.compile_dir(js_dir, "statistics", String.new)
      # suppose I have 3 files in the dir
      3.times do 
        result.should =~ /Original Size:/
      end
    end
  end

end
