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
      p "Video size="+Video.all.size.to_s
      p "video ids"
      Video.all.each do |v|
        p v.id
      end
      p "history video.ids"
      History.all.each do |h|
        p h.video_id
      end
      p "Video.join(his) size="+Video.joins(:histories).size.to_s
      p "add where title.length > 5 size="+Video.joins(:histories).where{ length(videos.title) > 5 }.size.to_s
      #"Video.hot size=0"
      p "Video.hot size="+(Video.hot).length.to_s
      p "Video.hot.weekly size="+(Video.hot.weekly).length.to_s
      p "WeeklyRank size="+WeeklyRank.all.size.to_s
      p "WeeklyRank update"
      WeeklyRank.update
      p "WeeklyRank size="+WeeklyRank.all.size.to_s
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
