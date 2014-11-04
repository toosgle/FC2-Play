require 'spec_helper'

describe HomeController, :type => :controller do
  include AuthHelper

  before(:all) do
    Video.start_scrape("update", 10000, 10001, 1, 0)
    @video = Video.order(:updated_at).last
  end

  before(:each) do
    @user = create(:user)
    session[:user_id] = @user.id
  end

  describe '#render_404' do
    it "should render 404 file" do
      #get :play, { title: 'not_existing_page_321' }
      #expect(response.status).to eq(404)
    end
  end

  describe '#index' do
    it "has a 200 status code" do
      get :index
      expect(response.code).to eq("200")
    end
  end

  describe '#test' do
    it "has a 200 status code" do
      get :test
      expect(response.code).to eq("200")
    end
  end

  describe '#log' do
    it "has a 200 status code" do
      get :log
      expect(response.code).to eq("200")
    end
  end

  describe '#play' do
    context "no problem" do
      it "has a 200 status code" do
        get :play, { title: @video.title }
        expect(response.code).to eq("200")
      end
    end

    context "limited by hourly" do
      it "should redirect to root_path" do
        1010.times { create(:history4limit) }
        get :play, { title: @video.title }
        expect(response).to redirect_to root_path
      end
    end

    #context "limited by personal"
    #  it "has a 200 status code" do
    #    100.times { create(:history, user_id: @user.id) }
    #    get :play, { title: @video.title }
    #    expect(response).to redirect_to root_path
    #  end
    #end

    context "video dose not exist" do
      it "should redirect_to root_path" do
        get :play, { title: "abcdRSpec" }
        expect(response).to redirect_to root_path
      end
    end
  end

  describe '#search' do
    it "has a 200 status code" do
      get :search, { keywords: "a b", bookmarks:"s", duration: "no" }
      expect(response.code).to eq("200")
    end
  end

  describe '#change_player_size' do
    before(:each) do
      session[:user_id] = nil
      session[:temp_id] = 123456
      session[:size] = 750
    end
    it "should change player size" do
      post :change_player_size, { size: "900", format: 'js' }
      expect(session[:size]).to eq 900
    end

    it "has a 200 status code" do
      post :change_player_size, { size: "900", format: 'js' }
      expect(response.code).to eq("200")
    end

    context "bad params was sent" do
      it "should not change player size" do
        post :change_player_size, { size: "899", format: 'js' }
        expect(session[:size]).to eq 750
      end
    end
  end

  describe '#report' do
    it "should delete successfully" do
      expect{
        delete :report, { title: @video.title }
      }.to change(Video, :count).by(-1)
    end

    it "should not delete" do
      expect{
        delete :report, { title: "abcdRSpec" }
      }.to change(Video, :count).by(0)
    end
  end

  describe '#admin' do
    it 'has 200 status code' do
      Record.create_all_his
      http_login
      get :admin
      expect(response.code).to eq("200")
    end
  end

end
