# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User manage gages', type: :system, js: true do
  let(:user) { create(:user) }
  # it_behaves_like 'authenticated', :gages_path
  # it_behaves_like 'authenticated', :new_gage_path

  feature 'User visits gage index' do
    scenario 'sees a list of gages' do
      create_list(:gage, 2, offset: 3600)

      visit gages_path(as: user)
      rows = all('.gage-row')

      rows.each do |row|
        expect(row).to have_content('conchos')
        expect(row).to have_link(href: 'http://example.com')
        expect(row).to have_content('+01:00')
      end
    end
  end

  feature 'User creates a new gage' do
    scenario 'sees the created gage on gages index' do
      visit new_gage_path(as: user)

      within '#gage-form' do
        fill_in 'gage[ibcw_id]', with: '19293'
        fill_in 'gage[name]', with: 'bravo'
        fill_in 'gage[url]', with: 'https://ibwc.gov/wad/373000_a.txt'
        fill_in 'gage[offset_hours]', with: '1'
        fill_in 'gage[offset_minutes]', with: '0'
        click_on 'Guardar'
      end

      row = first('.gage-row')

      expect(row).to have_content('bravo')
      expect(row).to have_link(href: 'https://ibwc.gov/wad/373000_a.txt')
      expect(row).to have_content('+01:00')
    end

    context 'when tries to create a gage with invalid data' do
      scenario 'sees a error message' do
        visit new_gage_path(as: user)

        within '#gage-form' do
          fill_in 'gage[ibcw_id]', with: '19293'
          fill_in 'gage[name]', with: ''
          fill_in 'gage[url]', with: 'ibwc.gov/wad/373000_a.txt'
          fill_in 'gage[offset_hours]', with: '14'
          fill_in 'gage[offset_minutes]', with: '30'
          click_on 'Guardar'
        end

        expect(page).to have_content(I18n.t('flash.failure.create'))
      end
    end
  end

  feature 'User updates a gage' do
    let!(:gage) { create(:gage, offset: 3600) }

    scenario 'see the changes on gage index' do
      visit gages_path(as: user)

      click_link(href: "/gages/#{gage.id}/edit")

      within '#gage-form' do
        fill_in 'gage[offset_hours]', with: '1'
        fill_in 'gage[offset_minutes]', with: '30'
        click_on 'Guardar'
      end

      row = first('.gage-row')

      expect(row).to have_content('+01:30')
    end

    context 'when tries to update with invalid data' do
      scenario 'sees an error message' do
        visit gages_path(as: user)
        click_link(href: "/gages/#{gage.id}/edit")
        within '#gage-form' do
          fill_in 'gage[name]', with: ''
          fill_in 'gage[offset_hours]', with: '14'
          fill_in 'gage[offset_minutes]', with: '14'
          click_on 'Guardar'
        end

        expect(page).to have_content(I18n.t('flash.failure.update'))
      end
    end
  end

  feature 'User deletes a gage' do
    scenario 'the deleted gage is not in the gage index' do
      gage = create(:gage)

      visit gages_path(as: user)

      click_link("destroy-gage-#{gage.id}")
      accept_alert

      expect(page).to have_no_css('.gage-row')
    end
  end
end
