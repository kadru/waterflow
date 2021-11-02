# frozen_string_literal: true

# Application component
class ApplicationComponent < ViewComponent::Base
  include Pagy::Frontend

  def content_security_policy_nonce
    request.content_security_policy_nonce
  end
end
