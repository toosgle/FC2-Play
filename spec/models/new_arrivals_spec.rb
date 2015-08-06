require 'rails_helper'

RSpec.describe NewArrival do
  describe '#update' do
    it 'should make ranks' do
      50.times { create(:video4newarrival) }
      NewArrival.update
      expect(NewArrival.all.size).to eq 23
      # factory girlで50個レコードを作ると23個がランキングINの対象になる
    end
  end
end
