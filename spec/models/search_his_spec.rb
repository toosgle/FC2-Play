require 'spec_helper'

describe SearchHis do
  describe '#create_record' do
    it 'create new record successfully' do
      expect do
        SearchHis.create_record('a b c', 's', 'no', 1)
      end.to change(SearchHis, :count).by(1)
    end
  end

  describe '#rename_user_history' do
    it 'rename tmp_user_id to new user_id' do
      create(:search_his, user_id: 1_234_567)
      create(:search_his, user_id: 1_234_567)
      new_user = create(:user)
      SearchHis.rename_user_history(1_234_567, new_user.id)
      expect(SearchHis.where(user_id: new_user.id).size).to eq(2)
    end
  end
end
