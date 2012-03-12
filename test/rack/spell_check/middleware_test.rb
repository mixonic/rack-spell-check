# require File.join(File.dirname(__FILE__), *%w[.. test_helper])
require 'test_helper'

describe Rack::SpellCheck::Middleware do

  before do
    @app = Rack::MockRequest.new(
      Rack::Builder.new {
        map '/' do
          use Rack::SpellCheck::Middleware
          run lambda {|env| [200, {'Content-Type' => 'text/html'}, 'Speling']}
        end
      }
    )
  end

  it "should log a misspelling" do
    Rack::SpellCheck::Middleware.any_instance.expects(:log_misspelling).with('Speling', ['Spelling', 'Spieling', 'Sapling', 'Spilling', 'Spoiling', 'Spooling', 'Spline', 'Spewing', 'Spellings', 'Pealing', 'Peeling', 'Sealing', 'Selling', 'Soling', 'Spleen', 'Sling', 'Speckling', 'Paling', 'Piling', 'Poling', 'Puling', 'Splint', "Spelling's"])
    @app.get '/'
  end

end
