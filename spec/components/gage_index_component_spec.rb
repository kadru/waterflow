# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GageIndexComponent, type: :component do
  it 'renders gages table' do
    gages_with_waterflows = create_list(:gage, 2, offset: 3600)
    all_gages = Gage.all
    pagy = Pagy.new count: all_gages.size, page: 1

    gages_with_waterflows.each do |gage_w|
      create(:waterflow, gage: gage_w, captured_at: Time.new(2021, 6, 12, 13, 15, 0, 0))
    end

    subject = GageIndexComponent.new(gages: gages_with_waterflows, pagy: pagy)
    render_inline(subject)

    expect(rendered_component).to have_content(translate!('gages.header.name'))
    expect(rendered_component).to have_content(translate!('gages.header.last_captured_at'))
    expect(rendered_component).to have_content(translate!('gages.header.ibcw_id'))
    gages_with_waterflows.each do |gage_w|
      expect(rendered_component).to have_content(gage_w.ibcw_id)
      expect(rendered_component).to have_content(gage_w.name)
      expect(rendered_component).to have_link(href: %r{http://example.com})
      expect(rendered_component).to have_content('2021/06/12 13:15')
      expect(rendered_component).to have_selector("#destroy-gage-#{gage_w.id}")
    end

    expect(rendered_component).to have_link(href: new_gage_path)
    expect(rendered_component).to have_selector("[data-tooltip='#{translate!('gages.add_gage')}']")
  end

  context 'when a gage has not waterflows' do
    it 'renders missing waterflow data' do
      create(:gage, offset: 3600)
      pagy = Pagy.new count: 1, page: 1

      subject = GageIndexComponent.new(gages: Gage.all, pagy: pagy)
      render_inline(subject)

      expect(rendered_component).to have_content(translate!('view_object.gage_view.missing_last_captured_at'))
    end
  end
end
