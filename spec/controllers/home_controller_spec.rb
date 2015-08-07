require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  include AuthHelper
  include DataHelper

  let(:video) { Video.order(:updated_at).last }
  let(:user) { create(:user) }

  before(:each) do
    create_base_data
  end

  describe '#render_404' do
    before do
      def controller.index
        render_404
      end
    end
    it 'should raise RoutingError' do
      get :index
      expect(response.code).to eq('404')
    end
  end

  describe '#index' do
    context 'user is registerd' do
      it 'has a 200 status code' do
        get :index
        expect(response.code).to eq('200')
      end
    end

    context 'user is not registered' do
      it 'has a 200 status code' do
        session[:user_id] = nil
        get :index
        expect(response.code).to eq('200')
      end
    end
  end

  describe '#log' do
    it 'has a 200 status code' do
      get :log
      expect(response.code).to eq('200')
    end
  end

  describe '#play' do
    context 'with not existance video' do
      it 'has a 302 status code' do
        get :play, title: video.title
        expect(response.code).to eq('302')
      end
    end

    # context 'limited by hourly' do
    #  it 'should redirect to root_path' do
    #    1010.times { create(:history4limit) }
    #    get :play, { title: video.title }
    #    expect(response).to redirect_to root_path
    #  end
    # end

    # context 'limited by personal'
    #  it 'has a 200 status code' do
    #    100.times { create(:history, user_id: @user.id) }
    #    get :play, { title: @video.title }
    #    expect(response).to redirect_to root_path
    #  end
    # end

    context 'video dose not exist' do
      it 'should redirect_to root_path' do
        get :play, title: 'abcdRSpec'
        expect(response).to redirect_to root_path
      end
    end
  end

  describe '#search' do
    it 'has a 200 status code' do
      get :search, keywords: 'a b', bookmarks: 's', duration: 'no'
      expect(response.code).to eq('200')
    end
  end

  describe '#report' do
    it 'should delete successfully' do
      expect do
        delete :report, title: video.title
      end.to change(Video, :count).by(-1)
    end
  end
end
