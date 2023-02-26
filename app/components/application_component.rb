# frozen_string_literal: true

# Application component
class ApplicationComponent < ViewComponent::Base
  include Pagy::Frontend

  delegate :content_security_policy_nonce, to: :request
end
