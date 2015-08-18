require 'rails_helper'
include DataHelper

RSpec.describe HomeController, type: :feature do
  before(:each) do
    create_base_data
    Fc2.scrape('adult', 10_000, 10_001)
  end

  context 'not login' do
    let(:video) { Video.last }
    it 'should not have fav list', js: true do
      visit '/'
      click_link('お気に入り')

      click_link('ユーザー登録')
      fill_in 'user_name', with: 'new_user'
      fill_in 'user_password', with: 'pswd'
      fill_in 'user_password_confirmation', with: 'pswd'
      click_button('登録')
      sleep 1

      expect(page).to have_content('登録しました')
    end
  end

  context 'login' do
    let(:video) { Video.last }
    it 'should add new fav', js: true do
      # ログイン
      visit '/'
      click_button('ログイン')
      fill_in 'name', with: 'testRspec'
      fill_in 'password', with: 'password'
      find('.modal-footer').click_button('ログイン')
      sleep 1

      # 検索
      fill_in 'keyword', with: video.title
      click_button('検　索')
      sleep 1
      expect(page).to have_content(video.title)
      click_link(video.title)

      # 再生ページ(play_specの代わり)
      expect(page.has_css?('#delete_video')).to be_truthy
      expect(page.has_css?('#add_fav')).to be_truthy

      fill_in 'fav_comment', with: 'お気に入りだー'
      click_button('お気に入り登録')

      click_link('お気に入り')
      sleep 1

      expect(page.find('#favTable_wrapper')).to have_content('お気に入りだー')
      expect(page.find('#favTable_wrapper')).to have_content(video.title)

      # 設定変更(setting_specの代わり)
      click_link('設定/使い方')
      click_button('大')
      sleep 1
      expect(page).to have_content('ウィンドウサイズを 大 に変更しました。')

      # 履歴チャック(history_specの代わり)
      visit '/'
      click_link('履歴')
      expect(page).to have_content(video.title)
    end
  end
end
