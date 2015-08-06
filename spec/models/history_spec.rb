require 'rails_helper'

RSpec.describe History do
  describe 'Association' do
    it { should belong_to(:user) }
    it { should belong_to(:video) }
  end

  describe '#create_record' do
    it 'should create record successfully' do
      create(:video1)
      expect do
        History.create_record(1, 'a b c', 20_001_001)
      end.to change(History, :count).by(1)
    end
  end

  describe '#rank_update' do
=begin
    before(:each) do
      700.times { create(:video4his) }
      700.times { create(:history) }
      10.times { create(:fav4his) }
    end
    it 'should update weekly rank' do
      WeeklyRank.update
      w_last = WeeklyRank.order(:updated_at).last.updated_at
      sleep 1
      History.rank_update
      expect(WeeklyRank.order(:updated_at).last.updated_at).not_to eq w_last
    end

    it 'should update monthly rank' do
      byebug
      MonthlyRank.update
      m_last = MonthlyRank.order(:updated_at).last.updated_at
      sleep 1
      History.rank_update
      expect(MonthlyRank.order(:updated_at).last.updated_at).not_to eq m_last
    end
=end
  end

  describe '#rename_user_history' do
    it 'rename tmp_user_id to new user_id' do
      create(:history, user_id: 1_234_567)
      create(:history, user_id: 1_234_567)
      new_user = create(:user)
      History.rename_user_history(1_234_567, new_user.id)
      expect(History.where(user_id: new_user.id).size).to eq(2)
    end
  end

  describe '#weekly_info_for_analyzer' do
    it 'should return 21 values' do
      results = History.weekly_info_for_analyzer
      expect(results.size).to eq 21
    end
  end
end
