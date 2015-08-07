require 'rails_helper'

RSpec.describe WindowsController, type: :controller do
  include AuthHelper

  describe '#change_window_size' do
    before(:each) do
      session[:user_id] = nil
      session[:temp_id] = 123_456
      session[:size] = 750
    end
    it 'should change player size' do
      post :change_size, size: '900', format: 'js'
      expect(session[:size]).to eq 900
    end

    it 'has a 200 status code' do
      post :change_size, size: '900', format: 'js'
      expect(response.code).to eq('200')
    end

    context 'bad params was sent' do
      it 'should not change player size' do
        post :change_size, size: '899', format: 'js'
        expect(session[:size]).to eq 750
      end
    end
  end

end
