# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Rivers reports', type: :system, js: true do
  feature 'generate river report' do
    let(:user) { create(:user) }

    context 'when given valid dates' do
      scenario 'sends an email and returns and success message' do
        create(:river_with_waterflows)

        visit new_reports_path(as: user)

        select('conchos', from: 'report_form_river_id', visible: :all)
        fill_in('report_form_start_date', with: '2020/05/21', visible: :all)
        fill_in('report_form_end_date', with: '2020/05/22', visible: :all)
        click_on('Generar')

        expect(page).to have_content(I18n.t('flash.success.report'))
      end
    end

    context 'when give invalid dates' do
      scenario 'shows a alert message' do
        create(:river_with_waterflows)

        visit new_reports_path(as: user)
        select('conchos', from: 'report_form_river_id', visible: :all)
        fill_in('report_form_start_date', with: '2020/05/24', visible: :all)
        fill_in('report_form_end_date', with: '2020/05/22', visible: :all)
        click_on('Generar')

        expect(page).to have_content(I18n.t('flash.failure.report'))
      end
    end
  end
end
