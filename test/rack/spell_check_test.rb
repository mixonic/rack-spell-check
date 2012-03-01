# require File.join(File.dirname(__FILE__), *%w[.. test_helper])
require 'test_helper'

describe Rack::SpellCheck do

  before do
    @app = Rack::MockRequest.new(
      Rack::Builder.new {
        map '/' do
          use Rack::SpellCheck
          run lambda {|env| [200, {}, 'Speling']}
        end
      }
    )
  end

  it "should log a misspelling" do
    Rack::SpellCheck.any_instance.expects(:log_misspelling).with('Speling', ['Spelling'])
    @app.get '/'
    assert false
  end

end
