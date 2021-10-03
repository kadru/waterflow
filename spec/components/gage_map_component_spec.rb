# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GageMapComponent, type: :component do
  around do |ex|
    ENV['MAPBOX_TOKEN'] = 'token'
    ex.run
    ENV.delete('MAPBOX_TOKEN')
  end

  it 'renders the map' do
    token = ENV['MAPBOX_TOKEN']
    gage = create(:gage)
    subject = GageMapComponent.new(gage: gage)
    render_inline(subject)

    expect(rendered_component).to have_selector("[id='gage_map_#{gage.id}']")
    expect(rendered_component).to have_selector(".js-gage-map[data-name='#{gage.name}']")
    expect(rendered_component).to have_selector(".js-gage-map[data-latitude='#{gage.latitude}']")
    expect(rendered_component).to have_selector(".js-gage-map[data-longitude='#{gage.longitude}']")
    expect(rendered_component).to have_selector(".js-gage-map[data-title='#{translate! 'marker'}']")
    expect(rendered_component).to have_selector(".js-gage-map[data-mapbox-token='#{token}']")
  end
end
