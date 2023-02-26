# frozen_string_literal: true

# Renders a nav bar link
class NavlinkMobileComponent < ViewComponent::Base
  attr_reader :text, :path, :method

  def initialize(text:, path:, method: :get)
    @text = text
    @path = path
    @method = method
  end

  def current_link_classes
    %w[bg-gray-900
       text-white block
       px-3
       py-2
       rounded-md
       text-base
       font-medium]
  end

  def link_classes
    %w[text-gray-300
       hover:bg-gray-700
       hover:text-white
       block
       px-3
       py-2
       rounded-md
       text-base
       font-medium]
  end
end
