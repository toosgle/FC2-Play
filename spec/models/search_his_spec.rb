require 'spec_helper'

describe SearchHis do
  describe '#create_record' do
    it 'create new record successfully' do
      expect do
        SearchHis.create_record('a b c', 's', 'no', 1)
      end.to change(SearchHis, :count).by(1)
    end
  end
end
