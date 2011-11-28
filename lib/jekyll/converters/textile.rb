module Jekyll

  class TextileConverter < Converter
    safe true

    pygments_prefix '<notextile>'
    pygments_suffix '</notextile>'

    def setup
      return if @setup
      require 'redcloth'
      @setup = true
    rescue LoadError
      STDERR.puts 'You are missing a library required for Textile. Please run:'
      STDERR.puts '  $ [sudo] gem install RedCloth'
      raise FatalException.new("Missing dependency: RedCloth")
    end

    def matches(ext)
      rgx = '(' + @config['textile_ext'].gsub(',','|') +')'
      ext =~ Regexp.new(rgx, Regexp::IGNORECASE)
    end

    def output_ext(ext)
      ".html"
    end

    def convert(content)
      setup
      
      restrictions = Array.new
      if !@config['redcloth'].nil?
        @config['redcloth'].each do |key, value|
          restrictions << key.to_sym if value
        end
      end

      r = RedCloth.new(content, restrictions)

      if !@config['redcloth'].nil? and !@config['redcloth']['hard_breaks'].nil?
        r.hard_breaks = @config['redcloth']['hard_breaks']
      end

      r.to_html
    end
  end

end
