require 'spec_helper'

describe UsersController, type: :controller  do
  before(:each) do
    @user = create(:user)
  end

  describe '#create' do
    let(:params) do
      {
        user: {
          name: name,
          password: 'password',
          password_confirmation: 'password'
        }
      }
    end

    context 'valid params' do
      let(:name) { 'testRspec1' }

      it 'should create new user ' do
        expect do
          post :create, params
        end.to change(User, :count).by(1)
      end

      it 'should rewrite tmp_user history' do
        create(:history, user_id: 1_234_567)
        create(:history, user_id: 1_234_567)
        session[:user_id] = 1_234_567
        expect do
          post :create, params
        end.to change(User, :count).by(1)
        expect(History.where(user_id: User.last).size).to eq 2
      end

      it 'should redirect to root' do
        post :create, params
        expect(response).to redirect_to root_path
      end
    end

    context 'username is already exist' do
      let(:name) { 'testRspec' }

      it 'should fail to create new user' do
        expect do
          post :create, params
        end.to change(User, :count).by(0)
      end
    end

    context 'bad params of confirmation' do
      let(:name) { 'testRspec2' }

      it 'should fail to create new user' do
        params[:user][:password_confirmation] = 'passwor111d'
        expect do
          post :create, params
        end.to change(User, :count).by(0)
      end
    end

    context 'no username' do
      let(:name) { nil }

      it 'should fail to create new user' do
        expect do
          post :create, params
        end.to change(User, :count).by(0)
      end
    end
  end

  describe '#update' do
    let(:params) do
      {
        user: {
          size: size
        },
        id: @user.id,
        format: 'js'
      }
    end
    context 'valid params' do
      let(:size) { '900' }

      it 'should update successfully' do
        put :update, params
        expect(User.order(:updated_at).last.size).to eq 900
      end
    end

    context 'invalid params' do
      let(:size) { '899' }

      it 'should not update' do
        last_update = User.order(:updated_at).last.updated_at
        sleep 1
        put :update, params
        expect(User.order(:updated_at).last.updated_at).to eq last_update
      end
    end
  end

  describe '#destroy' do
    it 'should destroy successfully' do
      expect do
        delete :destroy, id: @user.id
      end.to change(User, :count).by(-1)
    end

    it 'should redirect to root' do
      delete :destroy, id: @user.id
      expect(response).to redirect_to root_path
    end

    it 'should not destroy successfully' do
      # I don't know how to write test
    end
  end
end
