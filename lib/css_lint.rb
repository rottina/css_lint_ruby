module CSSLint
  class Lint
    attr_reader :gem_vendor_dir
    attr_reader :css
    attr_reader :options
    
    def initialize(*css_directories)
      @gem_vendor_dir = File.join(File.dirname(__FILE__), 'vendor')
      css_directories.empty? ? @css = error_message : @css = css_directories
    end

    def execute(*options)
      if @css == error_message
        puts @css
      else
        run_lint(*options)
      end
    end

    def error_message
      'Must provide css_lint a CSS file or directory'
    end
    
    def get_java_path
      `which java`.to_s.rstrip
    end

    def run_lint(*options)
      java_path = get_java_path
      raise "You do not have a Java installed, but it is required." unless java_path && !java_path.empty?
      
      options.empty? ? @options = '' : @options = options.join(' ') + ' '

      @css.each do |item|
        system("java -jar #{@gem_vendor_dir}/js.jar #{@gem_vendor_dir}/csslint-rhino.js $@ #{@options}#{item}")
      end
    end
  end
end
