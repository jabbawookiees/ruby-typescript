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
  end
end