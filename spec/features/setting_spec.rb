require 'rails_helper'
include DataHelper

RSpec.describe HomeController, type: :feature do
  before(:each) do
    create_base_data
  end

  context 'not login' do
    it 'should change window size', js: true do
      # 検索
      visit '/'
      click_link('設定/使い方')
      click_button('大')
      sleep 1
      expect(page).to have_content('ウィンドウサイズを 大 に変更しました。')
    end

    # 再生ページでのウィンドウサイズ変更は play_spec でやる

    it 'should appear register modal', js: true do
      # 検索
      visit '/'
      click_link('設定/使い方')
      sleep 1

      find('#fcfcplay_info').click_link('ユーザー登録')
      fill_in 'user_name', with: 'new_user'
      fill_in 'user_password', with: 'pswd'
      fill_in 'user_password_confirmation', with: 'pswd'
      click_button('登録')
      sleep 1

      expect(page).to have_content('登録しました')
    end
  end

  context 'login' do
    it 'should change window size', js: true do
      # ログイン
      visit '/'
      click_button('ログイン')
      fill_in 'name', with: 'testRspec'
      fill_in 'password', with: 'password'
      find('.modal-footer').click_button('ログイン')
      sleep 1

      # 設定変更
      click_link('設定/使い方')
      click_button('大')
      sleep 1
      expect(page).to have_content('ウィンドウサイズを 大 に変更しました。')
    end

    # 再生ページでのウィンドウサイズ変更は fav_spec でやる
  end
end
