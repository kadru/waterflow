# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GageComponent, type: :component do
  let(:gage) { create(:gage) }
  subject { described_class.new(gage: gage) }

  before do
    render_inline(subject)
  end

  it 'render the gage form' do
    expect(rendered_component).to have_css('form#gage-form')
  end

  context 'when the gages is new' do
    let(:gage) { build(:gage) }

    it 'renders with new title' do
      expect(rendered_component).to have_css('h3', text: 'Nuevo')
    end
  end

  context 'when the gage is saved' do
    let(:gage) { create(:gage) }

    it 'renders with saved title' do
      expect(rendered_component).to have_css('h3', text: 'Editando')
    end
  end
end
