require 'rails_helper'
include DataHelper

RSpec.describe UsersController, type: :feature do
  before(:each) do
    create_base_data
  end

  describe 'new user' do
    scenario 'create user and login', js: true do
      visit '/'
      click_button('新規登録')
      fill_in 'user_name', with: 'new_user'
      fill_in 'user_password', with: 'pswd'
      fill_in 'user_password_confirmation', with: 'pswd'
      click_button('登録')
      sleep 1

      expect(page).to have_content('登録しました')

      click_button('ログイン')
      fill_in 'name', with: 'new_user'
      fill_in 'password', with: 'pswd'
      find('.modal-footer').click_button('ログイン')
      sleep 1

      expect(page).to have_content('ログインしました')

      click_link('設定/使い方')
      sleep 1

      expect(page).to have_content('アカウント管理')
      click_button('アカウント削除')
      sleep 1
      click_link('削除')
      sleep 1
      expect(page).to have_content('アカウントを削除しました')

      click_button('ログイン')
      fill_in 'name', with: 'new_user'
      fill_in 'password', with: 'pswd'
      find('.modal-footer').click_button('ログイン')
      sleep 1

      expect(page).to have_content('IDかパスワードが間違っています')
    end

    scenario 'create user fail with not same password', js: true do
      visit '/'
      click_button('新規登録')
      fill_in 'user_name', with: 'new_user'
      fill_in 'user_password', with: 'pswd'
      fill_in 'user_password_confirmation', with: 'swd'
      click_button('登録')
      sleep 1

      expect(page).to have_content('パスワードが異なっています')

      click_button('ログイン')
      fill_in 'name', with: 'new_user'
      fill_in 'password', with: 'pswd'
      find('.modal-footer').click_button('ログイン')
      sleep 1

      expect(page).to have_content('IDかパスワードが間違っています')
    end

    scenario 'create user fail with existed user name', js: true do
      visit '/'
      click_button('新規登録')
      fill_in 'user_name', with: 'testRspec'
      fill_in 'user_password', with: 'pswd'
      fill_in 'user_password_confirmation', with: 'pswd'
      click_button('登録')
      sleep 1

      expect(page).to have_content('そのID名は既に使われています')

      click_button('ログイン')
      fill_in 'name', with: 'testRspec'
      fill_in 'password', with: 'pswd'
      find('.modal-footer').click_button('ログイン')
      sleep 1

      expect(page).to have_content('IDかパスワードが間違っています')
    end
  end
end
