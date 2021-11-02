# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'CspViolations', type: :request do
  describe 'POST /csp_violations' do
    it 'registers csp violations' do
      post csp_violations_path, params: {
        'csp-report' => {
          'document-uri' => 'http://localhost:3000/gages',
          'referrer' => '',
          'violated-directive' => 'style-src-attr',
          'effective-directive' => 'style-src-attr',
          'original-policy' => "default-src 'self' https:; font-src 'self' https: data:; img-src 'self' https: data:;",
          'disposition' => 'report',
          'blocked-uri' => 'inline',
          'line-number' => 6465,
          'column-number' => 19,
          'source-file' => 'http://localhost:3000/packs/js/application-59b1820171e59dba4c2d.js',
          'status-code' => 200,
          'script-sample' => ''
        }
      }

      expect(response).to have_http_status(204)
    end
  end
end
