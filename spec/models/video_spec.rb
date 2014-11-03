require 'spec_helper'

describe Video do

  describe 'Association' do
    it { should have_many(:favs) }
    it { should have_many(:histories) }
    it { should have_many(:monthly_ranks) }
    it { should have_many(:weekly_ranks) }
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

  describe '#available?' do
    context 'url of the video is not valid' do
      it 'should return false' do
        v = create(:video1)
        expect(v.available?).to be_falsey
      end
    end

    context 'the video is available on FC2Video' do
      it 'should return true' do
        Video.start_scrape("update", 10000, 10001, 1, 0)
        expect(Video.order(:updated_at).last.available?).to be_truthy
      end
    end
  end

  describe '#scrape' do
    it 'should scrape/create more than 1 videos' do
      Video.start_scrape("update", 10000, 10003, 4500, 4501)
      Video.start_scrape("update", 10000, 10001, 1, 0)
    expect(
      Video.where("updated_at > ?", Time.now-60).count
    ).to be_between(1, 150)
    end
  end

  describe '#search' do
    context 'no condition' do
      it 'should make expected sql' do
        expect(Video.search([],"no","no").to_sql).to eq \
          Video.where("1=1").order("bookmarks DESC").limit(200).to_sql
      end
    end

    context '[a]-s-s condition' do
      it 'should make expected sql' do
        expect(Video.search(["a"],"s","s").to_sql).to eq \
          Video.where("title LIKE '%a%'") \
                .where("1=1") \
                .where(bookmarks: 30..500) \
                .where(duration: '00:00'..'10:00') \
                .where(morethan100min: 0) \
                .order("bookmarks DESC") \
                .limit(200).to_sql
      end
    end

    context '[a,b]-m-m condition' do
      it 'should make expected sql' do
        expect(Video.search(["a", "b"],"m","m").to_sql).to eq \
          Video.where("title LIKE '%a%'") \
                .where("title LIKE '%b%'") \
                .where("1=1") \
                .where(bookmarks: 500..2000) \
                .where(duration: '10:00'..'30:00') \
                .where(morethan100min: 0) \
                .order("bookmarks DESC") \
                .limit(200).to_sql
      end
    end

    context '[]-l-l condition' do
      it 'should make expected sql' do
        expect(Video.search([],"l","l").to_sql).to eq \
          Video.where("1=1") \
                .where{ bookmarks >= 2000 } \
                .where(duration: '30:00'..'60:00') \
                .where(morethan100min: 0) \
                .order("bookmarks DESC") \
                .limit(200).to_sql
      end
    end

    context '["a"]-no-xl condition' do
      it 'should make expected sql' do
        expect(Video.search(["a"],"no","xl").to_sql).to eq \
          Video.where("title LIKE '%a%'") \
                .where("1=1") \
                .where("duration >= '60:00' or morethan100min = 1") \
                .order("bookmarks DESC") \
                .limit(200).to_sql
      end
    end
  end

end