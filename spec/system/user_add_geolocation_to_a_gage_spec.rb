# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User add geolocation to a gage', type: :system, js: true do
  it 'adds a geolocation to the gage' do
    user = create(:user, admin: true)
    gage = create(:gage)
    visit edit_gage_path(gage, as: user)

    fill_in(translate!('activerecord.attributes.gage.latitude'), with: '5.5')
    fill_in(translate!('activerecord.attributes.gage.longitude'), with: '5.5')

    click_button(translate!('helpers.submit.simple'))

    expect(page).to have_content(translate!('flash.success.update'))
    expect(page).to have_css('.js-gage-map', visible: false) # This renders a map
  end
end
