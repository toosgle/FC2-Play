require 'rails_helper'

RSpec.describe Video do
  describe 'Association' do
    it { should have_many(:favs) }
    it { should have_many(:histories) }
    it { should have_many(:monthly_ranks) }
    it { should have_many(:weekly_ranks) }
    it { should have_many(:new_arrivals) }
  end

  describe 'Validation' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:url) }
    it { should validate_presence_of(:views) }
    it { should validate_presence_of(:duration) }
    it { should validate_presence_of(:image_url) }
    it { should validate_presence_of(:bookmarks) }
    it { should validate_inclusion_of(:adult).in_array([true, false]) }
    it { should validate_inclusion_of(:morethan100min).in_array([true, false]) }
  end

  describe '#available_on_fc2?' do
    context 'url of the video is not valid' do
      it 'should return false' do
        v = create(:video1)
        expect(v.available_on_fc2?).to be_falsey
      end
    end

    context 'the video is available on FC2Video' do
      it 'should return true' do
        Fc2.scrape('adult', 10_000, 10_001)
        expect(Video.last.available_on_fc2?).to be_truthy
      end
    end
  end

  describe '#search' do
    context 'no condition' do
      it 'should make expected sql' do
        expect(Video.search([], 'no', 'no').to_sql).to eq \
          Video.where('1=1').order('bookmarks DESC').limit(200).to_sql
      end
    end

    context '[a]-s-s condition' do
      it 'should make expected sql' do
        expect(Video.search(['a'], 's', 's').to_sql).to eq \
          Video.where("title LIKE '%a%'")
          .where('1=1')
          .where(bookmarks: 30..500)
          .where(duration: '00:00'..'10:00')
          .where(morethan100min: 0)
          .order('bookmarks DESC')
          .limit(200).to_sql
      end
    end

    context '[a,b]-m-m condition' do
      it 'should make expected sql' do
        expect(Video.search(%w(a b), 'm', 'm').to_sql).to eq \
          Video.where("title LIKE '%a%'")
          .where("title LIKE '%b%'")
          .where('1=1') \
          .where(bookmarks: 500..2000)
          .where(duration: '10:00'..'30:00')
          .where(morethan100min: 0)
          .order('bookmarks DESC')
          .limit(200).to_sql
      end
    end

    context '[]-l-l condition' do
      it 'should make expected sql' do
        expect(Video.search([], 'l', 'l').to_sql).to eq \
          Video.where('1=1').where { bookmarks >= 2000 }
          .where(duration: '30:00'..'60:00')
          .where(morethan100min: 0)
          .order('bookmarks DESC')
          .limit(200).to_sql
      end
    end

    context '["a"]-no-xl condition' do
      it 'should make expected sql' do
        expect(Video.search(['a'], 'no', 'xl').to_sql).to eq \
          Video.where("title LIKE '%a%'")
          .where('1=1')
          .where("duration >= '60:00' or morethan100min = 1")
          .order('bookmarks DESC')
          .limit(200).to_sql
      end
    end
  end

  describe '#ref_url' do
    it 'should return the last part of URL' do
      v = Video.new(url: 'http://video.fc2.com/a/content/201505149BdT5mY0&t_holder')
      expect(v.ref_url).to eq('201505149BdT5mY0&t_holder')
    end
  end

  describe '#weekly_rank' do
    it 'same videos as WeeklyRanking' do
      150.times do |i|
        create(:video, id: i + 1)
        create(:weekly_rank, video_id: i + 1)
      end
      expect(Video.weekly_rank[0].id).to eq(WeeklyRank.first.video_id)
      expect(Video.weekly_rank.size).to eq(100)
    end
  end

  describe '#monthly_rank' do
    it 'same videos as MonthlyRank' do
      150.times do |i|
        create(:video, id: i + 1)
        create(:monthly_rank, video_id: i + 1)
      end
      expect(Video.monthly_rank.first.id).to eq(MonthlyRank.first.video_id)
      expect(Video.monthly_rank.size).to eq(100)
    end
  end

  describe '#user_histories' do
    it 'should be history list of the user' do
      create(:video, id: 1)
      create(:video, id: 2)
      create(:history, user_id: 1, video_id: 1)
      create(:history, user_id: 1, video_id: 2)
      expect(Video.user_histories(1).size).to eq(2)
    end
  end

  # weekly_rank と monthly_rank で担保しているので一旦パス
  describe '#list_of' do
  end

  # パス
  describe '#new_arrivals_list' do
  end

  describe '#check_available' do
    it 'should delete videos not in fc2' do
      Fc2.scrape('adult', 10_000, 10_001)
      availables = Video.count
      5.times { create(:video) }
      all = Video.count
      Video.check_available
      expect(all - 5).to eq availables
    end
  end
end
