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

RSpec::Matchers.define :raise_spec_error do |expected_exception_msg|
  define_method :actual_msg do
    @actual_msg
  end

  match do |block|
    begin
      block.call
      false
    rescue RSpec::Expectations::ExpectationNotMetError => rspec_error
      @actual_msg = rspec_error.message

      case expected_exception_msg
      when String
        actual_msg == expected_exception_msg
      when Regexp
        actual_msg =~ expected_exception_msg
      end
    end
  end

  failure_message_for_should do |block|
    <<MSG
expected RSpec::Expectations::ExpectationNotMetError with message:
#{expected_exception_msg}

got:
#{actual_msg}

Diff:
#{RSpec::Expectations::Differ.new.diff_as_string(actual_msg,expected_exception_msg.to_s)}
MSG
  end
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true

  config.extend  AssetHelpers
  config.include RSpec::Html::Matchers
end
