require 'spec_helper'

describe FavsController, type: :controller do
  let(:user) { create(:user) }
  let(:fav) { create(:fav1, user_id: user.id) }

  before(:each) do
    session[:user_id] = user.id
    fav.save
  end

  describe '#create' do
    let(:params) do
      {
        fav: {
          video_id: video_id,
          comment: 'abcde'
        },
        format: 'js'
      }
    end
    context 'valid params' do
      let(:video_id) { '10001001' }

      it 'should create new fav' do
        expect do
          post :create, params
        end.to change(Fav, :count).by(1)
      end

      it 'has a 200 status code' do
        post :create, params
        expect(response.code).to eq('200')
      end
    end

    context 'already has 100 favs' do
      let(:video_id) { '99999999' }

      it 'should fail to create new fav' do
        100.times { create(:fav, user_id: user.id) }
        expect do
          post :create, params
        end.to change(Fav, :count).by(0)
      end
    end

    context 'bad_params' do
      let(:video_id) { nil }

      it 'should fail to create new fav' do
        100.times { create(:fav, user_id: user.id) }
        expect do
          post :create, params
        end.to change(Fav, :count).by(0)
      end
    end

    context 'the bookmark has already exist' do
      let(:video_id) { '10001000' }

      it 'should fail to create new fav' do
        expect do
          post :create, params
        end.to change(Fav, :count).by(0)
      end
    end
  end

  describe '#update' do
    let(:params) do
      {
        fav: {
          video_id: video_id,
          comment: 'updated'
        },
        id: fav.id,
        format: 'js'
      }
    end
    context 'valid params' do
      let(:video_id) { '10001000' }

      it 'should update successfully' do
        put :update, params
        expect(Fav.order(:updated_at).last.comment).to eq 'updated'
      end

      it 'has 200 status code' do
        put :update, params
        expect(response.code).to eq '200'
      end
    end

    context 'invalid params' do
      let(:video_id) { nil }

      it 'should not update' do
        last_update = Fav.order(:updated_at).last.updated_at
        sleep 1
        put :update, params
        expect(Fav.order(:updated_at).last.updated_at).to eq last_update
      end
    end
  end

  describe '#destroy' do
    it 'should destroy successfully' do
      expect do
        delete :destroy, id: fav.id, format: 'js'
      end.to change(Fav, :count).by(-1)
    end

    it 'has 200 status code' do
      delete :destroy, id: fav.id, format: 'js'
      expect(response.code).to eq '200'
    end

    it 'should not destroy successfully' do
      others_fav = create(:fav, user_id: user.id + 1)
      expect do
        delete :destroy, id: others_fav.id, format: 'js'
      end.to change(Fav, :count).by(0)
    end
  end
end
