require 'spec_helper'

describe HomeController, type: :controller do
  include AuthHelper

  let(:video) { Video.order(:updated_at).last }
  let(:user) { create(:user) }

  before(:all) do
    Video.start_scrape('update', 10_000, 10_001, 1, 0)
  end

  before(:each) do
    session[:user_id] = user.id
    Video.limit(10).each do |v|
      (rand(5) + 1).times do
        create(:history4wrank, video_id: v.id, user_id: rand(5))
      end
    end
    History.rank_update
    NewArrival.update
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

    context 'window size is 590' do
      it 'has a 200 status code' do
        session[:size] = 590
        get :index
        expect(response.code).to eq('200')
      end
    end

    context 'window size is 750' do
      it 'has a 200 status code' do
        session[:size] = 750
        get :index
        expect(response.code).to eq('200')
      end
    end

    context 'window size is 900' do
      it 'has a 200 status code' do
        session[:size] = 900
        get :index
        expect(response.code).to eq('200')
      end
    end
  end

  describe '#test' do
    it 'has a 200 status code' do
      get :test
      expect(response.code).to eq('200')
    end
  end

  describe '#log' do
    it 'has a 200 status code' do
      get :log
      expect(response.code).to eq('200')
    end
  end

  describe '#play' do
    context 'no problem' do
      it 'has a 200 status code' do
        get :play, title: video.title
        expect(response.code).to eq('200')
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

  describe '#change_player_size' do
    before(:each) do
      session[:user_id] = nil
      session[:temp_id] = 123_456
      session[:size] = 750
    end
    it 'should change player size' do
      post :change_player_size, size: '900', format: 'js'
      expect(session[:size]).to eq 900
    end

    it 'has a 200 status code' do
      post :change_player_size, size: '900', format: 'js'
      expect(response.code).to eq('200')
    end

    context 'bad params was sent' do
      it 'should not change player size' do
        post :change_player_size, size: '899', format: 'js'
        expect(session[:size]).to eq 750
      end
    end
  end

  describe '#report' do
    it 'should delete successfully' do
      expect do
        delete :report, title: video.title
      end.to change(Video, :count).by(-1)
    end

    it 'should not delete' do
      expect do
        delete :report, title: 'abcdRSpec'
      end.to change(Video, :count).by(0)
    end
  end

  describe '#admin' do
    it 'has 200 status code' do
      Record.create_all_his
      http_login
      get :admin
      expect(response.code).to eq('200')
    end
  end
end
