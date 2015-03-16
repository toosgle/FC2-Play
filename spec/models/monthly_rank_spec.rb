require 'spec_helper'

describe MonthlyRank do

  describe 'Association' do
    it { should belong_to(:video) }
  end

  describe '# Video.hot.monthly size' do
    it 'should make 500 ranks' do
      700.times { create(:video4his) }
      700.times { create(:history) }
      10.times { create(:fav4his) }
      MonthlyRank.update
      expect(MonthlyRank.all.size).to eq 300
    end
  end

  describe '#create_dummy' do
    #it 'should create 50 records' do
    #  MonthlyRank.create_dummy
    #  expect(MonthlyRank.all.size).to eq 500
    #end
  end

end
