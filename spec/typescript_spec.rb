require 'spec_helper'

describe TypeScript do
  describe '#compile' do
    before(:each) do
      FileUtils.rm_rf("#{ @project_path }/test_data")
      FileUtils.cp_r("#{ @project_path }/spec/data", "#{ @project_path }/test_data")
    end

    after(:each) do
      FileUtils.rm_rf("#{ @project_path }/test_data")
    end

    it 'properly compiles good code without source maps' do
      TypeScript.compile_file("#{ @project_path }/test_data/good.ts")
      expect(File).to exist("#{ @project_path }/test_data/good.js")
      expect(File).not_to exist("#{ @project_path }/test_data/good.js.map")
    end

    it 'properly compiles good code with source maps' do
      TypeScript.compile_file("#{ @project_path }/test_data/good.ts", :source_map => true)
      expect(File).to exist("#{ @project_path }/test_data/good.js")
      expect(File).to exist("#{ @project_path }/test_data/good.js.map")
    end

    it 'properly compiles good code with amd modules without source maps' do
      TypeScript.compile_file("#{ @project_path }/test_data/good_using_module.ts", :module => 'amd')
      expect(File).to exist("#{ @project_path }/test_data/good_using_module.js")
      expect(File).not_to exist("#{ @project_path }/test_data/good_using_module.js.map")
    end

    it 'properly compiles good code with amd modules with source maps' do
      TypeScript.compile_file("#{ @project_path }/test_data/good_using_module.ts", :source_map => true, :module => 'amd')
      expect(File).to exist("#{ @project_path }/test_data/good_using_module.js")
      expect(File).to exist("#{ @project_path }/test_data/good_using_module.js.map")
    end

    it 'properly compiles good code with commonjs modules without source maps' do
      TypeScript.compile_file("#{ @project_path }/test_data/good_using_module.ts", :module => 'commonjs')
      expect(File).to exist("#{ @project_path }/test_data/good_using_module.js")
      expect(File).not_to exist("#{ @project_path }/test_data/good_using_module.js.map")
    end

    it 'properly compiles good code with commonjs modules with source maps' do
      TypeScript.compile_file("#{ @project_path }/test_data/good_using_module.ts", :source_map => true, :module => 'commonjs')
      expect(File).to exist("#{ @project_path }/test_data/good_using_module.js")
      expect(File).to exist("#{ @project_path }/test_data/good_using_module.js.map")
    end

    it 'properly compiles good code without source maps targeting es5' do
      TypeScript.compile_file("#{ @project_path }/test_data/es5.ts", :target => 'ES5')
      expect(File).to exist("#{ @project_path }/test_data/es5.js")
      expect(File).not_to exist("#{ @project_path }/test_data/es5.js.map")
    end

    it 'properly compiles good code with source maps targeting es5' do
      TypeScript.compile_file("#{ @project_path }/test_data/es5.ts", :source_map => true, :target => 'ES5')
      expect(File).to exist("#{ @project_path }/test_data/es5.js")
      expect(File).to exist("#{ @project_path }/test_data/es5.js.map")
    end

    it 'properly rejects bad code' do
      expect { print(TypeScript.compile_file("#{ @project_path }/test_data/bad.ts")) }.to raise_error TypeScript::Error
    end

    it 'properly supports the :output option' do
      TypeScript.compile_file("#{ @project_path }/test_data/good.ts", :output => "#{ @project_path }/test_data/target.js")
      expect(File).to exist("#{ @project_path }/test_data/target.js")
    end

    it 'supports nested folders in :output without source maps' do
      TypeScript.compile_file("#{ @project_path }/test_data/good.ts", :output => "#{ @project_path }/test_data/nested/even/deeper/target.js")
      expect(File).to exist("#{ @project_path }/test_data/nested/even/deeper/target.js")
      expect(File).not_to exist("#{ @project_path }/test_data/nested/even/deeper/target.js.map")
    end

    it 'supports nested folders in :output with source maps' do
      TypeScript.compile_file("#{ @project_path }/test_data/good.ts", :output => "#{ @project_path }/test_data/nested/even/deeper/target.js", :source_map => true)
      expect(File).to exist("#{ @project_path }/test_data/nested/even/deeper/target.js")
      expect(File).to exist("#{ @project_path }/test_data/nested/even/deeper/target.js.map")
    end
    
    it 'properly compiles references separately, if specified' do 
      TypeScript.compile_file("#{ @project_path }/test_data/reference_user.ts", :separate => true)
      expect(File).to exist("#{ @project_path }/test_data/reference_user.js")
      
      File.open("#{ @project_path }/test_data/reference_user.js", "r") do |file|
        found = false
        file.each_line do |line|
          if line =~ /I am the referenced file/
            found = true
            break
          end
        end
        expect(found).to eq(false)
      end
    end
    
    it 'properly compiles references separately to a different folder, if specified' do 
      TypeScript.compile_file("#{ @project_path }/test_data/reference_user.ts", :separate => true, :output => "#{ @project_path }/test_data/nested/target.js")
      expect(File).to exist("#{ @project_path }/test_data/nested/target.js")
      
      File.open("#{ @project_path }/test_data/nested/target.js", "r") do |file|
        found = false
        file.each_line do |line|
          if line =~ /I am the referenced file/
            found = true
            break
          end
        end
        expect(found).to eq(false)
      end
    end

    it 'properly compiles references together, if separate is not specified' do 
      TypeScript.compile_file("#{ @project_path }/test_data/reference_user.ts")
      expect(File).to exist("#{ @project_path }/test_data/reference_user.js")
      
      File.open("#{ @project_path }/test_data/reference_user.js", "r") do |file|
        found = false
        file.each_line do |line|
          if line =~ /I am the referenced file/
            found = true
            break
          end
        end
        expect(found).to eq(true)
      end
    end
  end
end
