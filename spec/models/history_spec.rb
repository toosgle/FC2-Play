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
      150.times { create(:video4his) }
      150.times { create(:history) }
    end
    it 'should update weekly rank' do
      p "History size="+History.all.size.to_s
      p "Video.hot size="+(Video.hot).length.to_s
      p "Video.hot.weekly size="+(Video.hot.weekly).length.to_s
      p "WeeklyRank size="+WeeklyRank.all.size.to_s
      p "WeeklyRank update"
      WeeklyRank.update
      p "WeeklyRank size="+WeeklyRank.all.size.to_s
      p "==== manual update ===="
      p "Video.hot.weekly.each do |video|"
      Video.hot.weekly.each do |video|
        p "video_id = "+video.id.to_s
        p "video_title = "+video.title
        record = WeeklyRank.new(video_id: video.id)
        p record
        record.save
        p record
      end
      p "==== end ===="
      sleep 1
      w_last = WeeklyRank.order(:updated_at).last.updated_at
      sleep 1
      History.rank_update
      expect(WeeklyRank.order(:updated_at).last.updated_at).not_to eq w_last
    end

    it 'should update monthly rank' do
      p "History size="+History.all.size.to_s
      p "MonthlyRank size="+MonthlyRank.all.size.to_s
      p "MonthlyRank update"
      MonthlyRank.update
      p "MonthlyRank size="+MonthlyRank.all.size.to_s
      p "sleep 1"
      sleep 1
      p "MonthlyRank size="+MonthlyRank.all.size.to_s
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
