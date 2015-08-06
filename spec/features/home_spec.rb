require 'rails_helper'
include DataHelper

RSpec.describe HomeController, type: :feature do
  before(:each) do
    create_base_data
  end

  describe 'necessary info' do
    it 'should be found in top page', js: true do
      visit '/'
      expect(page).to have_content('NewArritalVideo')
      click_link('人気')
      sleep 1
      expect(page).to have_content('f*ckingtosh11')
      click_link('資料館')
      sleep 1
      expect(page).to have_content('キーワード')
      click_link('設定/使い方')
      sleep 1
      expect(page).to have_content('画面サイズ')
    end
  end

  describe 'search' do
    scenario 'search videos', js: true do
      visit '/'
      fill_in 'keyword', with: 'f*ckingtosh'
      click_button('検　索')
      sleep 1
      expect(page).to have_content('110 entries')

      fill_in 'keyword', with: 'f*ckingtosh108'
      select 'これはヤバい(2000~)', from: 'bookmarks'
      select '少し短め(10~30分)', from: 'duration'
      click_button('検　　索')
      sleep 1
      expect(page).to have_content('10:23')
      expect(page).to have_content('1 entries')
    end
  end
end
