# frozen_string_literal: true

module TranslationsHelpers
  def translate!(key)
    I18n.t(key, raise: true)
  end

  def component_translate!(key)
    translate(key, raise: true)
  end
end

RSpec.configure do |config|
  config.include TranslationsHelpers
end
