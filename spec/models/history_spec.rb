require 'spec_helper'

describe History do

  describe 'Association' do
    it { should belong_to(:user) }
    it { should belong_to(:video) }
  end

  describe '#create_record' do
    it 'should create record successfully' do
      create(:video1)
      expect{
        History.create_record(1, "a b c", 20001001)
      }.to change(History, :count).by(1)
    end
  end

  describe '#rank_update' do
    before(:each) do
      150.times { create(:history) }
      150.times { create(:video4his) }
    end
    it 'should update weekly rank' do
      WeeklyRank.update
      w_last = WeeklyRank.order(:updated_at).last.updated_at
      sleep 1
      History.rank_update
      expect(WeeklyRank.order(:updated_at).last.updated_at).not_to eq w_last
    end

    it 'should update monthly rank' do
      MonthlyRank.update
      m_last = MonthlyRank.order(:updated_at).last.updated_at
      sleep 1
      History.rank_update
      expect(MonthlyRank.order(:updated_at).last.updated_at).not_to eq m_last
    end
  end

  describe '#weekly_info_for_analyzer' do
    it 'should return 21 values' do
      results = History.weekly_info_for_analyzer
      expect(results.size).to eq 21
    end
  end

end
