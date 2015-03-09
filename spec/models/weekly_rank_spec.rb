require 'spec_helper'

describe WeeklyRank do

  describe 'Association' do
    it { should belong_to(:video) }
  end

  describe '# Video.hot.weekly scope' do
    # timecopで時間を指定した履歴を作ってテストをすれば良いけど…
    # めんどう
  end

  describe '#create_dummy' do
    #it 'should create 50 records' do
    #  WeeklyRank.create_dummy
    #  expect(WeeklyRank.all.size).to eq 500
    #end
  end

end
