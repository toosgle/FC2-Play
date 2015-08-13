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

  describe '#calc_recommend' do
    it 'should return 1' do
      video = create(:video, views: 5000, bookmarks: 20)
      expect(NewArrival.calc_recommend(video)).to eq 1
    end

    it 'should return 2' do
      video = create(:video, views: 5000, bookmarks: 62)
      expect(NewArrival.calc_recommend(video)).to eq 2
    end

    it 'should return 3' do
      video = create(:video, views: 8_000, bookmarks: 100)
      expect(NewArrival.calc_recommend(video)).to eq 3
    end

    it 'should return 4' do
      video = create(:video, views: 10_000, bookmarks: 125)
      expect(NewArrival.calc_recommend(video)).to eq 4
    end

    it 'should return 5' do
      video = create(:video, views: 50_000, bookmarks: 1000)
      expect(NewArrival.calc_recommend(video)).to eq 5
    end
  end
end
