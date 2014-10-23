require "open3"

module TypeScript
  VERSION = '0.1.1'

  class Error < StandardError
  end

  class << self
    def typescript_path
      ENV['TYPESCRIPT_SOURCE_PATH']
    end

    def node_compile(*args)
      if typescript_path
        cmd = [typescript_path] + args
      else
        cmd = ['tsc'] + args
      end
      cmd = cmd.join(' ')
      stdin, stdout, stderr, wait_thr = Open3.popen3(cmd)
      stdin.close
      [stdout.read, stderr.read, wait_thr]
    end

    def flatten_options(options)
      args = []
      if options[:output]
        args << '--out' << options[:output]
      end

      if options[:source_map]
        args << '--sourceMap'
      end
      
      if options[:module]
        args << '--module' << options[:module]
      end
      
      if options[:target]
        args << '--target' << options[:target]
      end

      return args
    end


    # Compiles a TypeScript file to JavaScript.
    #
    # @param [String] filepath the path to the TypeScript file
    # @param [Hash] options the options for the execution
    # @option options [String] :output the output path
    # @option options [Boolean] :source_map create the source map or not
    # @option options [String] :module module type to compile for (commonjs or amd)
    # @option options [String] :target the target to compile toward: ES3 (default) or ES5
    def compile_file(filepath, options={})
      options = options.clone
      if not options[:output]
        options[:output] = filepath.gsub(/\.ts$/, '.js')
      end
      output_filename = options[:output]
      args = [filepath] + flatten_options(options)
      stdout, stderr, wait_thr = node_compile(*args)

      if wait_thr.nil?
        success = stdout.empty? and stderr.empty?
      else
        success = wait_thr.value == 0
      end

      if success
        result = {
          :js => output_filename,
          :stdout => stdout,
        }
        if options[:source_map]
          result[:source_map] = output_filename + '.map'
        end
        return result
      else
        raise TypeScript::Error, ( stderr.empty? ? stdout : stderr )
      end
    end

  end
end
