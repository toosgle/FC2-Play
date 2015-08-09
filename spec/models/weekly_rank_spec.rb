require 'rails_helper'

RSpec.describe WeeklyRank do
  describe 'Association' do
    it { should belong_to(:video) }
  end

  context 'getting information from fc2' do
    before(:each) do
      create(:history, user_id: 1,
                       video_id: 20_001_002,
                       created_at: DateTime.now - 91)
      create(:history, user_id: 1,
                       video_id: 20_001_003,
                       created_at: DateTime.now - 91)
      create(:history, user_id: 1,
                       video_id: 20_001_003,
                       created_at: DateTime.now - 89)
      create(:history, user_id: 1,
                       video_id: 20_001_003,
                       created_at: DateTime.now - 89)
      create(:history, user_id: 1,
                       video_id: 20_001_002,
                       created_at: DateTime.now - 89)
      create(:history, user_id: 2,
                       video_id: 20_001_002,
                       created_at: DateTime.now - 1)
      create(:history, user_id: 2,
                       video_id: 20_001_003,
                       created_at: DateTime.now - 1)
      create(:history, user_id: 3,
                       video_id: 20_001_002,
                       created_at: DateTime.now - 1)
      create(:history, user_id: 3,
                       video_id: 20_001_003,
                       created_at: DateTime.now - 1)
      600.times do |i|
        create(:video4his, id: 20_001_000 + i)
        create(:history, id: 20_001_000 + i, video_id: 20_001_000 + i)
      end
    end

    describe '#update' do
      it 'should create a weekly rank' do
        WeeklyRank.delete_all
        WeeklyRank.update
        expect(WeeklyRank.all.count).to be 2
      end
    end

    describe '#iku_point_in_three_month' do
      it 'should correctly calculate' do
        expect(WeeklyRank.iku_point_in_three_month[20_001_002]).to eq 1
        expect(WeeklyRank.iku_point_in_three_month[20_001_003]).to eq 2
      end
    end

    describe '#was_iku_video?' do
      it 'should be true and false depends on cases' do
        pre = create(:history, user_id: 1)
        his = create(:history, user_id: 2)
        expect(WeeklyRank.was_iku_video?(pre, his, false)).to eq false
        expect(WeeklyRank.was_iku_video?(pre, his, true)).to eq true
        pre = create(:history, user_id: 2, created_at: DateTime.now - 1)
        expect(WeeklyRank.was_iku_video?(pre, his, true)).to eq true
      end
    end

    describe '#will_iku_video?' do
      it 'should be true and false depends on cases' do
        pre = create(:history, user_id: 1)
        his = create(:history, user_id: 1)
        expect(WeeklyRank.will_iku_video?(pre, his)).to eq true
        pre = create(:history, user_id: 1, created_at: DateTime.now - 1)
        expect(WeeklyRank.will_iku_video?(pre, his)).to eq false
        pre = create(:history, user_id: 2)
        expect(WeeklyRank.will_iku_video?(pre, his)).to eq false
      end
    end

    describe '#three_month_his' do
      it 'should contain records in 3 months' do
        expect(WeeklyRank.three_month_his.size).to eq 607
      end
    end

    describe '#sort_by_iku_per_play' do
      it 'should correctly sort' do
        point = WeeklyRank.iku_point_in_three_month
        arr = WeeklyRank.sort_by_iku_per_play(point)
        expect(arr[0][0]).to eq 20_001_003
        expect(arr[0][1]).to eq 0.4
        expect(arr[1][0]).to eq 20_001_002
        expect(arr[1][1]).to eq 0.25
      end
    end

    describe '#playtimes' do
      it 'should correctly count' do
        expect(WeeklyRank.playtimes[20_001_002]).to eq 4
        expect(WeeklyRank.playtimes[20_001_003]).to eq 5
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
