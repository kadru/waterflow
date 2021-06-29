# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GageIndexComponent, type: :component do
  it 'renders gages table' do
    gages = create_list(:gage, 2, offset: 3600)
    pagy = Pagy.new count: gages.size, page: 1

    subject = GageIndexComponent.new(gages: gages, pagy: pagy)
    render_inline(subject)

    expect(rendered_component).to have_content('Nombre')
    expect(rendered_component).to have_content('Zona Horaria')
    gages.each do |gage|
      expect(rendered_component).to have_content(gage.name)
      expect(rendered_component).to have_link(href: 'http://example.com')
      expect(rendered_component).to have_content('+01:00')
      expect(rendered_component).to have_selector("#destroy-gage-#{gage.id}")
    end

    expect(rendered_component).to have_link(href: new_gage_path)
  end
end
