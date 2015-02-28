require 'spec_helper'

describe MonthlyRank do

  describe 'Association' do
    it { should belong_to(:video) }
  end

  describe '# Video.hot.monthly scope' do
    it 'should make expected sql' do
      month_ago = DateTime.now-30
      expect(Video.hot.monthly.to_sql).to eq \
       Video.joins(:histories) \
            .where{ length(videos.title) > 5 } \
            .where{ videos.title !~ '%Removed%' } \
            .where{ histories.created_at > month_ago } \
            .group("videos.title") \
            .order("count(videos.title) DESC") \
            .limit(500).to_sql
    end
  end

  describe '#create_dummy' do
    it 'should create 50 records' do
      MonthlyRank.create_dummy
      expect(MonthlyRank.all.size).to eq 500
    end
  end

end
