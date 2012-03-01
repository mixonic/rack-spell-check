require 'raspell'

module Rack

  class SpellCheck

    def initialize app
      @app = app
      @speller = Aspell.new("en_US")
      @speller.suggestion_mode = Aspell::NORMAL
      @misspellings = {}
      @whitelist = %w{
        Matt Beale Spinto Spinto's spinto
        matt beale www
        css js scss CSS SCSS SASS CoffeeScript coffeescript
        li td GitHub pre YAML CNAME
        yoursubdomain
      }
    end

    def call env
      @app.call(env).tap do |response|
        begin
          if response[1]["Content-Type"] =~ /html/
            spell_check response[2].body
          end
        rescue StandardError => e 
          Rails.logger.warn "SpellCheck failed: #{e.message}"
        end
      end
    end
    
    def spell_check body 
      started_at = Time.now
      dom = (if body =~ /<body/
        Nokogiri::HTML.parse( body )
      else
        Nokogiri::HTML.fragment( body )
      end)
      reported_words = []
      dom.xpath('//*').each do |node|
        next unless node.text.present?
        node.text.
          # Strip out URLs.
          gsub(%r{[a-zA-Z0-9\.:/]+\.(?:co|net|org)[a-zA-Z0-9\.:/?&%]+}, '').
          # For each word.
          scan(%r{[A-Za-z\u2019'&;]+}) do |word|
          # Change HTML escaped and UTF-8 apostrophes to single quotes.
          word.gsub!(%r{\u2019|&rsquo;}, "'")
          key = word.downcase
          next if @whitelist.include?(word) || reported_words.include?(key)
          reported_words << key
          check_word word
        end
      end 
      Rails.logger.info "SpellChecked in #{(Time.now-started_at).seconds} seconds."
    end

    def check_word word
      key = word.downcase
      if @misspellings.has_key?(key) && @misspellings[key][:suggestions]
        log_misspelling word, @misspellings[key][:suggestions]
      else
        if @speller.check(word)
          @misspellings[key] = { checked: true }
        else
          @misspellings[key] = { checked: true, suggestions: @speller.suggest(word) }
          check_word word
        end
      end
    end

    def log_misspelling word, suggestions
      Rails.logger.warn "SpellCheck [#{word}]: #{suggestions[0..5].join ', '}"
    end
  
  end

end
