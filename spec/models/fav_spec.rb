require 'rails_helper'

RSpec.describe Fav do
  let(:user) { create(:user) }
  let(:fav) { create(:fav) }

  describe 'Association' do
    it { should belong_to(:user) }
    it { should belong_to(:video) }
  end

  describe 'Validation' do
    it { should validate_presence_of(:video_id) }
    it { should validate_presence_of(:user_id) }
  end

  describe '#exist?' do
    before(:each) do
      create(:fav1)
    end
    context 'user have not faved yet' do
      it 'should return false' do
        f = Fav.new(user_id: 1, video_id: 99_999_999)
        expect(f.exist?).to be_falsey
      end
    end

    context 'user have already favd' do
      it 'should return true' do
        f = Fav.new(user_id: 1, video_id: 10_001_000)
        expect(f.exist?).to be_truthy
      end
    end
  end

  describe '#more_than_100?' do
    context 'number of favs is less than 100' do
      it 'should can create new fav' do
        f = Fav.new(user_id: 10_001_000, video_id: 10_001_000)
        expect(f.more_than_100?).to be_falsey
      end
    end

    context 'number of favs is more than 100' do
      it 'should cannot create new fav' do
        100.times { create(:fav) }
        f = Fav.new(user_id: 1, video_id: 99_999_998)
        expect(f.more_than_100?).to be_truthy
      end
    end
  end
end
