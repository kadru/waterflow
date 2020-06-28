# frozen_string_literal: true

RSpec.shared_examples 'authenticated' do |path|
  context 'when is not authenticated' do
    it 'redirects to sign_in path' do
      test_path = send(path)
      visit(test_path)

      expect(current_path).to eq(sign_in_path)
    end
  end
end
