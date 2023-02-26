# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User manage gages', type: :system, js: true do
  let(:user) { create(:admin) }

  feature 'User visits gage index' do
    scenario 'sees a list of gages' do
      gages = create_list(:gage_with_waterflows, 2, offset: 3600)
      gages.each_with_index do |gage, index|
        create(:waterflow, gage:, captured_at: Time.zone.local(2021, 6, 12, index, 15))
      end
      gages.each(&:reload)

      visit gages_path(as: user)
      rows = all('.gage-row')

      rows.each do |row|
        expect(row).to have_content('conchos')
        expect(row).to have_link(href: %r{http://example.com/})
      end

      gages.each do |gage|
        expect(page).to have_content(gage.last_waterflow_captured_at.to_formatted_s(:report))
      end
    end
  end

  feature 'User creates a new gage' do
    scenario 'sees the created gage on edit page' do
      visit new_gage_path(as: user)

      within '#gage-form' do
        fill_in 'gage[ibcw_id]', with: '19293'
        fill_in 'gage[name]', with: 'bravo'
        fill_in 'gage[url]', with: 'https://ibwc.gov/wad/373000_a.txt'
        fill_in 'gage[offset_hours]', with: '1'
        fill_in 'gage[offset_minutes]', with: '0'
        click_on 'Guardar'
      end

      expect(page).to have_content(translate!('flash.success.create'))
      expect(page).to have_field('gage[ibcw_id]', with: '19293')
      expect(page).to have_field('gage[name]', with: 'bravo')
      expect(page).to have_field('gage[url]', with: 'https://ibwc.gov/wad/373000_a.txt')
      expect(page).to have_field('gage[offset_hours]', with: '1')
      expect(page).to have_field('gage[offset_minutes]', with: '0')
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

    context 'when user is not admin' do
      scenario 'see a unauthorized error message' do
        user = create(:user, admin: false)
        visit new_gage_path(as: user)

        expect(page).to have_content(translate!('flash.unauthorized'))
      end
    end
  end

  feature 'User updates a gage' do
    let!(:gage) { create(:gage, offset: 3600) }

    scenario 'see the changes on gage edit page' do
      visit gages_path(as: user)

      click_link(href: "/gages/#{gage.id}/edit")

      within '#gage-form' do
        fill_in 'gage[offset_hours]', with: '12'
        fill_in 'gage[offset_minutes]', with: '30'
        click_on 'Guardar'
      end

      expect(page).to have_field('gage[offset_hours]', with: '12')
      expect(page).to have_field('gage[offset_minutes]', with: '30')
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

    context 'when user is not admin' do
      scenario 'see a unauthorized error message' do
        user = create(:user, admin: false)
        visit gages_path(as: user)
        click_link(href: "/gages/#{gage.id}/edit")

        expect(page).to have_content(translate!('flash.unauthorized'))
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

    context 'when user is not admin' do
      scenario 'see a unauthorized error message' do
        user = create(:user, admin: false)
        gage = create(:gage)

        visit gages_path(as: user)

        click_link("destroy-gage-#{gage.id}")
        accept_alert

        expect(page).to have_content(translate!('flash.unauthorized'))
      end
    end
  end

  feature 'Users search for a gage by name' do
    scenario 'sees gages that matches the given name' do
      create(:gage, name: 'Conchos')
      create(:gage, name: 'Texas')

      visit gages_path(as: user)

      fill_in translate!('gages.search'), with: 'Conchos'
      click_on translate!('btns.search')

      expect(page).to have_content('Conchos')
      expect(page).to_not have_content('Texas')
    end

    context 'when there is not matches' do
      it 'sees a message of not results' do
        create(:gage, name: 'Conchos')
        create(:gage, name: 'Texas')

        visit gages_path(as: user)

        fill_in translate!('gages.search'), with: 'not matches'
        click_on translate!('btns.search')

        expect(page).to have_content(translate!('flash.without_results'))
      end
    end
  end
end
