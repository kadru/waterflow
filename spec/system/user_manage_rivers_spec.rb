# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User manage rivers', type: :system, js: true do
  let(:user) { create(:user) }
  # it_behaves_like 'authenticated', :rivers_path
  # it_behaves_like 'authenticated', :new_river_path

  feature 'User visits river index' do
    scenario 'sees a list of rivers' do
      create_list(:river, 2, offset: 3600)

      visit rivers_path(as: user)
      rows = all('.river-row')

      rows.each do |row|
        expect(row).to have_content('conchos')
        expect(row).to have_link(href: 'http://example.com')
        expect(row).to have_content('+01:00')
      end
    end
  end

  feature 'User creates a new river' do
    scenario 'sees the created river on rivers index' do
      visit new_river_path(as: user)

      within '#river-form' do
        fill_in 'river[ibcw_id]', with: '19293'
        fill_in 'river[name]', with: 'bravo'
        fill_in 'river[url]', with: 'https://ibwc.gov/wad/373000_a.txt'
        fill_in 'river[offset_hours]', with: '1'
        fill_in 'river[offset_minutes]', with: '0'
        click_on 'Guardar'
      end

      row = first('.river-row')

      expect(row).to have_content('bravo')
      expect(row).to have_link(href: 'https://ibwc.gov/wad/373000_a.txt')
      expect(row).to have_content('+01:00')
    end

    context 'when tries to create a river with invalid data' do
      scenario 'sees a error message' do
        visit new_river_path(as: user)

        within '#river-form' do
          fill_in 'river[ibcw_id]', with: '19293'
          fill_in 'river[name]', with: ''
          fill_in 'river[url]', with: 'ibwc.gov/wad/373000_a.txt'
          fill_in 'river[offset_hours]', with: '14'
          fill_in 'river[offset_minutes]', with: '30'
          click_on 'Guardar'
        end

        expect(page).to have_content(I18n.t('flash.failure.create'))
      end
    end
  end

  feature 'User updates a river' do
    let!(:river) { create(:river, offset: 3600) }

    scenario 'see the changes on river index' do
      visit rivers_path(as: user)

      click_link(href: "/rivers/#{river.id}/edit")

      within '#river-form' do
        fill_in 'river[offset_hours]', with: '1'
        fill_in 'river[offset_minutes]', with: '30'
        click_on 'Guardar'
      end

      row = first('.river-row')

      expect(row).to have_content('+01:30')
    end

    context 'when tries to update with invalid data' do
      scenario 'sees an error message' do
        visit rivers_path(as: user)
        click_link(href: "/rivers/#{river.id}/edit")
        within '#river-form' do
          fill_in 'river[name]', with: ''
          fill_in 'river[offset_hours]', with: '14'
          fill_in 'river[offset_minutes]', with: '14'
          click_on 'Guardar'
        end

        expect(page).to have_content(I18n.t('flash.failure.update'))
      end
    end
  end

  feature 'User deletes a river' do
    scenario 'the deleted river is not in the river index' do
      river = create(:river)

      visit rivers_path(as: user)

      click_link("destroy-river-#{river.id}")
      accept_alert

      expect(page).to have_no_css('.river-row')
    end
  end
end
