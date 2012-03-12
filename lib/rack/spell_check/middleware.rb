require 'raspell'
require 'nokogiri'

module Rack
  module SpellCheck

    class Middleware

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
              case response[2]
              when Rack::Response
                spell_check_html response[2].body
              when String
                spell_check_html response[2]
              when Array
                spell_check_html response[2].join
              end
            end
          rescue StandardError => e 
            Rack::SpellCheck.logger.warn "SpellCheck failed: #{e.message}"
          end
        end
      end

      def spell_check_html body
        with_benchmark do
          dom = (if body =~ /<body/
            Nokogiri::HTML.parse( body )
          else
            Nokogiri::HTML.fragment( body )
          end)
          nodes = dom.xpath('//*')
          if nodes.empty?
            spell_check body
          else
            reported_words = []
            nodes.each do |node|
              next unless node.text.present?
              spell_check node.text, reported_words
            end 
          end
        end
      end
      
      def spell_check body, reported_words=[] 
        with_benchmark do
          body.
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
      end

      def with_benchmark
        started_at = Time.now
        yield
        logger.info "SpellChecked in #{((Time.now-started_at) * 1000).round(2)} milliseconds."
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
        logger.info "SpellCheck [#{word}]: #{suggestions[0..5].join ', '}"
      end

      def logger
        Rack::SpellCheck.logger
      end
    
    end
  
  end
end
