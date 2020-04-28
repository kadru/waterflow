# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Reports', type: :system, js: true do
  describe 'Download reports' do
    context 'when given valid dates' do
      it 'downloads a report file'
    end

    context 'when give invalid dates' do
      xit 'shows a alert message' do
        visit '/reports/new'
        start_date = page.find('start_date')
        end_date = page.find('end_date')
        start_date.fill_in 'día', with: 1
        start_date.fill_in 'mes', with: 1
        start_date.fill_in 'año', with: 2018

        end_date.fill_in 'día', with: 1
        end_date.fill_in 'mes', with: 1
        end_date.fill_in 'año', with: 2017

        expect(page).to have_content('Fechas incorrectas')
      end
    end
  end
end
