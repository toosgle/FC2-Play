require 'rails_helper'

RSpec.describe MonthlyRank do
  before(:each) do
    700.times do |i|
      create(:video4his, id: 20_002_000 + i)
      create(:history, id: 20_002_000 + i, video_id: 20_002_000 + i)
    end
    create(:history, id: 20_002_997, video_id: 20_002_000)
    create(:history, id: 20_002_998, video_id: 20_002_100)
    create(:history, id: 20_002_999, video_id: 20_002_100)
    create_list(:fav4his, 10)
  end

  describe 'Association' do
    it { should belong_to(:video) }
  end

  describe '# Video.hot.monthly size' do
    it 'should make 300 ranks' do
      MonthlyRank.update
      expect(MonthlyRank.all.size).to eq 300
    end
  end

  describe '#videos_order_by_point' do
    it 'should order by point' do
      expect(MonthlyRank.videos_order_by_point.first).to eq 20_002_100
    end
  end

  describe '#calc_last_month_point' do
    it 'should correctly calculate' do
      expect(MonthlyRank.calc_last_month_point[20_002_100]).to eq 3
      expect(MonthlyRank.calc_last_month_point[20_002_000]).to eq 2
    end
  end

  describe '#last_month_his' do
    it 'limit 500 record' do
      expect(MonthlyRank.last_month_his.length).to eq 500
    end

    it 'should have correct value' do
      expect(MonthlyRank.last_month_his.first[:count]).to eq 3
    end
  end

  describe '#calc_last_week_point' do
    it 'should correctly calculate' do
      expect(MonthlyRank.calc_last_week_point([])[20_002_100]).to eq 24
      expect(MonthlyRank.calc_last_week_point({})[20_002_000]).to eq 16
      point = {}
      point[20_002_100] = 4
      expect(MonthlyRank.calc_last_week_point(point)[20_002_100]).to eq 28
    end
  end

  describe '#last_week_his' do
    it 'limit 500 record' do
      expect(MonthlyRank.last_week_his.length).to eq 500
    end

    it 'should have correct value' do
      expect(MonthlyRank.last_week_his.first[:count]).to eq 3
    end
  end

  describe '#calc_therr_month_favs_point' do
    it 'should correctly calculate' do
      id = MonthlyRank.three_month_favs.first.video_id
      expect(MonthlyRank.calc_therr_month_favs_point({})[id]).to eq 100
      point = {}
      point[id] = 10
      expect(MonthlyRank.calc_therr_month_favs_point(point)[id]).to eq 110
    end
  end

  describe '#three_month_favs' do
    it 'should contain record in 3 months' do
      expect(MonthlyRank.three_month_favs.size).to eq 10
    end
  end

  describe '#create_dummy' do
    it 'should create 500 dummies' do
      MonthlyRank.create_dummy
      expect(MonthlyRank.all.size).to eq 500
    end
  end
end
