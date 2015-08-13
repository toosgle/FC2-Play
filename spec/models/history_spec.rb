require 'rails_helper'

RSpec.describe History do
  describe 'Association' do
    it { should belong_to(:user) }
    it { should belong_to(:video) }
  end

  describe '#rename_user_history' do
    it 'rename tmp_user_id to new user_id' do
      create(:history, user_id: 1_234_567)
      create(:history, user_id: 1_234_567)
      new_user = create(:user)
      History.rename_user_history(1_234_567, new_user.id)
      expect(History.where(user_id: new_user.id).size).to eq(2)
    end
  end

  describe '#weekly_report' do
    it 'should return 21 values' do
      results = History.weekly_report
      expect(results.size).to eq 21
    end
  end
end
