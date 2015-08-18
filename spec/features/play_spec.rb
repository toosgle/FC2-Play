require 'rails_helper'
include DataHelper

RSpec.describe HomeController, type: :feature do
  before(:each) do
    create_base_data
    Fc2.scrape('adult', 10_000, 10_000)
  end

  context 'not login' do
    let(:video) { Video.last }
    it 'should play successfully', js: true do
      # 検索
      visit '/'
      fill_in 'keyword', with: video.title
      click_button('検　索')
      sleep 1
      expect(page).to have_content(video.title)
      click_link(video.title)

      # 再生ページ
      expect(page.has_css?('#delete_video')).to be_truthy

      # 設定変更(setting_specの代わり)
      click_link('設定/使い方')
      click_button('大')
      sleep 1
      expect(page).to have_content('ウィンドウサイズを 大 に変更しました。')
    end
  end

  context 'login' do
    # fav_specの方で重複しているので、ここではパス
  end
end
