# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationComponent, type: :component do
  describe '#content_security_policy_nonce' do
    it 'returns the request nonce' do
      application_component = described_class.new

      expect(application_component).to respond_to(:content_security_policy_nonce)
    end
  end
end
