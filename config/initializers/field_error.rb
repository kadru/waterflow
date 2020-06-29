# frozen_string_literal: true

ActionView::Base.field_error_proc = proc do |html_tag, instance|
  input = Nokogiri::HTML::DocumentFragment.parse(html_tag).children.first
  input.add_class 'invalid'
  "#{input}<span class=\"helper-text\" data-error=\"#{instance.error_message.join(' ')}\"></span>"
    .html_safe
end
