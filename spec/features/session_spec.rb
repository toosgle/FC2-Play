require 'rails_helper'
include DataHelper

RSpec.describe SessionsController, type: :feature do
  before(:each) do
    create_base_data
  end

  describe 'session' do
    scenario 'login success', js: true do
      visit '/'
      click_button('ログイン')
      fill_in 'name', with: 'testRspec'
      fill_in 'password', with: 'password'
      find('.modal-footer').click_button('ログイン')
      sleep 1

      expect(page).to have_content('ログインしました')

      click_link('設定/使い方')
      sleep 1

      expect(page).to have_content('アカウント管理')
    end

    scenario 'login fail', js: true do
      visit '/'
      click_button('ログイン')
      fill_in 'name', with: 'testRspec'
      fill_in 'password', with: 'passwrd'
      find('.modal-footer').click_button('ログイン', match: :smart)
      sleep 1

      expect(page).to have_content('IDかパスワードが間違っています')
      click_link('設定/使い方')
      sleep 1

      expect(page).not_to have_content('アカウント管理')
    end
  end
end
