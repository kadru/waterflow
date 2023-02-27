# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Health checks', type: :request do
  describe 'GET /health' do
    it 'returns status 200' do
      get health_path

      expect(response).to have_http_status(:ok)
    end
  end
end
