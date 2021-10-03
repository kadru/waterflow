# frozen_string_literal: true

module TranslationHelpers
  def translate!(*args, **keyword_args)
    I18n.t(*args, **keyword_args, raise: true)
  end
end

RSpec.configure do |config|
  config.include TranslationsHelpers
end
