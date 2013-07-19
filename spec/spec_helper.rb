require 'rspec/core'

if defined?(SimpleCov)
  SimpleCov.start do
    add_group 'Main', '/lib/'
  end
end

require 'rspec-html-matchers'

module AssetHelpers

  ASSETS = File.expand_path('../fixtures/%s.html',__FILE__)

  def asset name
    asset_content = fixtures[name] ||= IO.read(ASSETS%name)
    let(:rendered) { asset_content }
  end

  private

  def fixtures
    @assets ||= {}
  end

end

module CustomHelpers

  def raise_spec_error msg
    raise_error RSpec::Expectations::ExpectationNotMetError, msg
  end

end

RSpec.configure do |config|
  config.extend  AssetHelpers
  config.include CustomHelpers
  config.include RSpec::Html::Matchers
end
