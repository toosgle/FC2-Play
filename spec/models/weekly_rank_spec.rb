require 'spec_helper'

describe WeeklyRank do

  describe 'Association' do
    it { should belong_to(:video) }
  end

  describe '# Video.hot.weekly scope' do
    it 'should make expected sql' do
      week_ago = DateTime.now-7
      expect(Video.hot.weekly.to_sql).to eq \
       Video.joins(:histories) \
            .where{ length(videos.title) > 5 } \
            .where{ videos.title !~ '%Removed%' } \
            .where{ histories.created_at > week_ago } \
            .group("videos.title") \
            .order("count(videos.title) DESC") \
            .limit(100).to_sql
    end
  end

  describe '#create_dummy' do
    it 'should create 50 records' do
      WeeklyRank.create_dummy
      expect(WeeklyRank.all.size).to eq 50
    end
  end

end
