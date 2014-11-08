require 'spec_helper'

describe SessionsController, :type => :controller do

  let(:user) { create(:user) }

  let(:params) {
    {
      name: "testRspec",
      password: "password"
    }
  }

  describe "#create" do
    it "should login successfully " do
      user #create_user
      post :create, params
      expect(User.find(session[:user_id]).name).to eq "testRspec"
    end

    it "should fail to login" do
      params[:password] = "password1"
      post :create, params
      expect(session[:user_id]).to eq nil
    end

    it "should redirect to root" do
      post :create, params
      expect(response).to redirect_to root_path
    end
  end

  describe "#destroy" do
    before(:each) do
      post :create, params
    end
    it "should logout successfully " do
      delete :destroy, {:id => user.id}
      expect(session[:user_id]).to eq nil
    end

    it "should redirect to root" do
      delete :destroy, {:id => user.id}
      expect(response).to redirect_to root_path
    end
  end

end
