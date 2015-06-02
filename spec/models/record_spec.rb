require 'spec_helper'

describe Record do
  describe '#create_all_his' do
    it 'create many records' do
      start = Date.new(2014, 10, 8)
      days = (Date.today - start).to_i
      rest_days = (Date.today - start).to_i % 7
      weeks = ((days - rest_days) / 7) + 1
      Record.create_all_his
      expect(Record.all.size).to eq weeks * 7
    end
  end

=begin this cannot pass on TravisCI
  describe '#create_yesterday_his' do
    it 'create new 7 records' do
      start_day = Date.new(2014, 10, 8)
      Timecop.freeze(start_day + 14) do
        expect do
          Record.create_yesterday_his
        end.to change(Record, :count).by(7)
      end
    end
  end
=end

  describe '#create_reports' do
    it 'returns 8 reports' do
      start_day = Date.new(2014, 10, 8)
      Timecop.freeze(start_day + 7) do
        Record.create_all_his
        results = Record.create_reports
        expect(results.size).to eq 8
      end
    end
  end
end
