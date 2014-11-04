require 'spec_helper'

describe Record do

  describe '#create_all_his' do
    it 'create many records' do
      start = Date::new(2014, 10, 8)
      days = (Date.today-start+1).to_i
      Record.create_all_his
      expect(Record.all.size).to eq days*6
    end
  end

  describe '#create_yesterday_his' do
    it 'create new 6 records' do
      expect{
        Record.create_yesterday_his
      }.to change(Record, :count).by(6)
    end
  end

  describe '#create_reports' do
    it 'resurns 6 reports' do
      Record.create_all_his
      results = Record.create_reports(5)
      expect(results.size).to eq 6
    end
  end
end
