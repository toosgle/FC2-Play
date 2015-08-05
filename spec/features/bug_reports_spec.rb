require 'rails_helper'
include DataHelper

RSpec.describe BugReport, type: :feature do
  before(:each) do
    create_base_data
  end

  describe 'create a bug report' do
    scenario 'report a bug', js: true do
      pre_count = BugReport.count
      visit '/'
      click_button('バグ報告')
      fill_in 'content', with: '重大なバグがありました'
      click_button('送信')
      save_and_open_page

      expect(page).to have_content('ご報告ありがとうございました')

      expect(BugReport.count - pre_count).to eq 1
      expect(BugReport.last.content).to eq '重大なバグがありました'
    end
  end
end
