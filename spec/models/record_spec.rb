require 'spec_helper'

describe Record do
  describe '#create_all_his' do
    it 'create many records' do
      start = Date.new(2014, 10, 8)
      days = (Date.today - start).to_i
      rest_days = (Date.today - start).to_i % 7
      weeks = ((days - rest_days) / 7) + 1
      Record.create_all_his
      expect(Record.all.size).to eq weeks * 6
    end
  end

=begin this cannot pass on TravisCI
  describe '#create_yesterday_his' do
    it 'create new 6 records' do
      start_day = Date.new(2014, 10, 8)
      Timecop.freeze(start_day + 14) do
        expect do
          Record.create_yesterday_his
        end.to change(Record, :count).by(6)
      end
    end
  end
=end

  describe '#create_reports' do
    it 'returns 7 reports' do
      start_day = Date.new(2014, 10, 8)
      Timecop.freeze(start_day + 7) do
        Record.create_all_his
        results = Record.create_reports
        expect(results.size).to eq 7
      end
    end
  end
end
