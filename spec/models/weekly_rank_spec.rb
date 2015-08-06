require 'rails_helper'

RSpec.describe WeeklyRank do
  describe 'Association' do
    it { should belong_to(:video) }
  end

  context 'getting information from fc2' do
    before(:each) do
      600.times do |i|
        create(:video4his, id: 20_001_000 + i)
        create(:history, id: 20_001_000 + i, video_id: 20_001_000 + i)
      end
      create_list(:fav4his, 10)
      Video.start_scrape('update', 10_000, 10_001, 1, 0)
      Video.limit(20).each do |v|
        (rand(5) + 1).times do
          create(:history, video_id: v.id, user_id: rand(5))
        end
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
end
