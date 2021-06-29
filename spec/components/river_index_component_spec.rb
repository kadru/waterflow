# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RiverIndexComponent, type: :component do
  it 'renders rivers table' do
    rivers = create_list(:river, 2, offset: 3600)
    pagy = Pagy.new count: rivers.size, page: 1

    subject = RiverIndexComponent.new(rivers: rivers, pagy: pagy)
    render_inline(subject)

    expect(rendered_component).to have_content('Nombre')
    expect(rendered_component).to have_content('Zona Horaria')
    rivers.each do |river|
      expect(rendered_component).to have_content(river.name)
      expect(rendered_component).to have_link(href: 'http://example.com')
      expect(rendered_component).to have_content('+01:00')
      expect(rendered_component).to have_selector("#destroy-river-#{river.id}")
    end

    expect(rendered_component).to have_link(href: new_river_path)
  end
end
