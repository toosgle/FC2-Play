require 'rails_helper'

RSpec.describe Survey do
  describe 'Validation' do
    it { should validate_presence_of(:result) }
  end

  describe '#report' do
    it 'should return 5 values' do
      results = Survey.report
      expect(results.size).to eq 5 + 1 # [0] is nil
    end
  end
end
