# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Reports', type: :system, js: true do
  feature 'Download reports' do
    context 'when given valid dates' do
      scenario 'downloads a report file' do
        create(:river_with_waterflows)

        visit '/reports/new'

        select('conchos', from: 'report_form_river_id', visible: :all)
        fill_in('report_form_start_date', with: '05/21/2020', visible: :all)
        fill_in('report_form_end_date', with: '05/22/2020', visible: :all)
        click_on('Generar')

        expect(page).to have_content('El reporte será enviado a tu correo')
      end
    end

    context 'when give invalid dates' do
      scenario 'shows a alert message'
    end
  end
end
