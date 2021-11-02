# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CspViolationsController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/csp_violations').to route_to('csp_violations#create')
    end
  end
end
