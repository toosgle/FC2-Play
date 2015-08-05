require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:user) { create(:user) }

  describe '#create' do
    let(:params) do
      {
        name: 'testRspec',
        password: password
      }
    end

    context 'valid params' do
      let(:password) { 'password' }

      it 'should login successfully ' do
        user # create_user
        post :create, params
        expect(User.find(session[:user_id]).name).to eq 'testRspec'
      end

      it 'should redirect to root' do
        post :create, params
        expect(response).to redirect_to root_path
      end
    end

    context 'invalid params' do
      let(:password) { 'password1' }

      it 'should fail to login' do
        post :create, params
        expect(session[:user_id]).to eq nil
      end
    end
  end

  describe '#destroy' do
    let(:params) do
      {
        name: 'testRspec',
        password: 'password'
      }
    end

    before(:each) do
      post :create, params
    end
    it 'should logout successfully ' do
      delete :destroy, id: user.id
      expect(session[:user_id]).to eq nil
    end

    it 'should redirect to root' do
      delete :destroy, id: user.id
      expect(response).to redirect_to root_path
    end
  end
end
