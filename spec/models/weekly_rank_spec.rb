require 'spec_helper'

describe WeeklyRank do

  describe 'Association' do
    it { should belong_to(:video) }
  end

  before(:each) do
    600.times { create(:video4his) }
    600.times { create(:history) }
    10.times { create(:fav4his) }
    Video.start_scrape("update", 10000, 10001, 1, 0)
    Video.limit(20).each do |v|
      (rand(5)+1).times { create(:history, video_id: v.id, user_id: rand(5)) }
      create(:fav, video_id: v.id) if rand(3) == 0
    end
    History.rank_update
    NewArrival.update
  end

  describe '# Video.hot.weekly scope' do
    it 'should create a weekly rank' do
      WeeklyRank.delete_all
      WeeklyRank.update
      expect(WeeklyRank.all.size).to be > 0
    end
  end

  describe '#create_dummy' do
    it 'should create 500 dummies' do
      MonthlyRank.create_dummy
      expect(MonthlyRank.all.size).to eq 500
    end
  end

end
