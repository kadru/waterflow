# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationComponent, type: :component do
  describe '#content_security_policy_nonce' do
    it 'returns the request nonce' do
      expect(subject).to respond_to(:content_security_policy_nonce)
    end
  end
end
