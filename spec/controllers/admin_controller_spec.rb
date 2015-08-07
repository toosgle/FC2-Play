require 'rails_helper'

RSpec.describe AdminController, type: :controller do
  include AuthHelper

  describe '#admin' do
    it 'has 200 status code' do
      Record.create_all_his
      http_login
      get :index
      expect(response.code).to eq('200')
    end
  end
end
