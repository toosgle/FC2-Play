require 'spec_helper'

describe UsersController, :type => :controller  do

  before(:each) do
    @user = create(:user)
  end

  describe "#create" do
    let(:params) {
      {
        user: {
          name: name,
          password: "password",
          password_confirmation: "password"
        }
      }
    }

    context "valid params" do
      let(:name) { "testRspec1" }

      it "should create new user " do
        expect{
          post :create, params
        }.to change(User, :count).by(1)
      end

      it "should redirect to root" do
        post :create, params
        expect(response).to redirect_to root_path
      end
    end

    context 'username is already exist' do
      let(:name) { "testRspec" }

      it "should fail to create new user" do
        expect{
          post :create, params
        }.to change(User, :count).by(0)
      end
    end

    context 'bad params of confirmation' do
      let(:name) { "testRspec2" }

      it "should fail to create new user" do
        params[:user][:password_confirmation] = "passwor111d"
        expect{
          post :create, params
        }.to change(User, :count).by(0)
      end
    end

    context 'no username' do
      let(:name) { nil }

      it "should fail to create new user" do
        expect{
          post :create, params
        }.to change(User, :count).by(0)
      end
    end
  end

  describe "#update" do
    let(:params) {
      {
        user: {
          size: size
        },
        id: @user.id,
        format: 'js'
      }
    }
    context "valid params" do
      let(:size) { "900" }

      it "should update successfully" do
        put :update, params
        expect(User.order(:updated_at).last.size).to eq 900
      end
    end

    context "invalid params" do
      let(:size) { "899" }

      it "should not update" do
        last_update = User.order(:updated_at).last.updated_at
        sleep 1
        put :update, params
        expect(User.order(:updated_at).last.updated_at).to eq last_update
      end
    end
  end

  describe "#destroy" do
    it "should destroy successfully" do
      expect{
        delete :destroy, {:id => @user.id}
      }.to change(User, :count).by(-1)
    end

    it "should redirect to root" do
      delete :destroy, {:id => @user.id}
      expect(response).to redirect_to root_path
    end

    it "should not destroy successfully" do
      #I don't know how to write test
    end
  end

end
