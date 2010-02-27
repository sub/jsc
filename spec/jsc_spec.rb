
require File.join(File.dirname(__FILE__), %w[spec_helper])

        COMPILE_CODE = <<-EOU
function hello(name) {
  alert('Hello, ' + name)
}
hello('New user');
EOU

        ERROR_CODE = <<-EOU
functiont hello(name) {
  alert('Hello, ' + name)
}
hello('New user');
        EOU

        WARNING_CODE = <<-EOU
function hello(name) {
	return;
  alert('Hello, ' + name)
}
hello('New user');
        EOU

describe JSCompiler do

   describe 'Use the web service through API' do

    describe 'Put all keys in the request' do

      before do
        @request = JSCompiler.create_json_request(COMPILE_CODE)
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
        @request = JSCompiler.create_json_request(COMPILE_CODE)
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
        @resp = JSCompiler.compile(COMPILE_CODE, false, "compiled_code", "SIMPLE_OPTIMIZATIONS", "default")
      end
 
      it 'should receive the compiled code' do
        @resp.should_not be_nil
      end
    end
    
    describe 'compile code and find errors' do
      before do
        @resp = JSCompiler.compile(ERROR_CODE, false, "errors", "SIMPLE_OPTIMIZATIONS", "default")
      end
      
      it 'should return the result string' do
        @resp.should match(/Error n./)
      end
    end

    describe 'compile code and find warnings' do
      before do
        @resp = JSCompiler.compile(WARNING_CODE, false, "warnings", "SIMPLE_OPTIMIZATIONS", "default")
      end
      
      it 'should return the result string' do
        @resp.should match(/Warning n./)
      end  
    end

    describe 'compile code and obtain statistics' do
      before do
        @resp = JSCompiler.compile(COMPILE_CODE, false, "statistics", "SIMPLE_OPTIMIZATIONS", "")
      end
  
      it 'should return the result string' do
        @resp.should match(/Original Size:/)
      end
    end
  end

  describe 'FULL code compile' do
    describe 'without errors or warnings' do
      before do
        @resp = JSCompiler.full_compile(COMPILE_CODE, false, "SIMPLE_OPTIMIZATIONS", "")
      end
 
      it 'should receive the compiled code' do
        @resp.should_not be_nil
      end
    end
    
    describe 'and get errors' do
      before do
        @resp = JSCompiler.full_compile(ERROR_CODE, false, "SIMPLE_OPTIMIZATIONS", "")
      end
      
      it 'should return the result string' do
        @resp.should match(/Error n./)
      end
    end

    describe 'and get warnings' do
      before do
        @resp = JSCompiler.full_compile(WARNING_CODE, false, "SIMPLE_OPTIMIZATIONS", "")
      end
      
      it 'should return the result string' do
        @resp.should match(/Warning n./)
      end  
    end

  end

  describe 'read .js file' do
    before do
      #test file
      @file_name = 'js/compiled_code.js'
      @file_not_found = 'js/not_found.js'
    end

    it 'should return the code without errors' do
      lambda { JSCompiler.read_file(@file_name) }.should_not raise_error
    end

    it 'should raise exception if file not found' do
      lambda { JSCompiler.read_file(@file_not_found) }.should raise_error
    end
  end
  
  # TODO
  # describe 'compile a whole directory' do

  #   it 'should get statistics for every file' do
  #     js_dir = "js"
  #     result = JSCompiler.compile_dir(js_dir, "statistics", "")
  #     # suppose I have 3 files in the dir
  #     3.times do 
  #       result.should =~ /Original Size:/
  #     end
  #   end
  # end

end
