require 'spec_helper'

describe UsersController, :type => :controller  do

  before(:each) do
    @user = create(:user)
    @params = {
      user: {
        name: "testRspec1",
        password: "password",
        password_confirmation: "password"
      }
    }
  end

  describe "#create" do
    it "should create new user " do
      expect{
        post :create, @params
      }.to change(User, :count).by(1)
    end

    context 'username is already exist' do
      it "should fail to create new user" do
        @bad_params = {
          user: {
            name: "testRspec",
            password: "password",
            password_confirmation: "password"
          }
        }
        expect{
          post :create, @bad_params
        }.to change(User, :count).by(0)
      end
    end

    context 'bad params of confirmation' do
      it "should fail to create new user" do
        @bad_params = {
          user: {
            name: "testRspec2",
            password: "password",
            password_confirmation: "passwor111d"
          }
        }
        expect{
          post :create, @bad_params
        }.to change(User, :count).by(0)
      end
    end

    context 'no username' do
      it "should fail to create new user" do
        @bad_params = {
          user: {
            password: "password",
            password_confirmation: "password"
          }
        }
        expect{
          post :create, @bad_params
        }.to change(User, :count).by(0)
      end
    end

    it "should redirect to root" do
      post :create, @params
      expect(response).to redirect_to root_path
    end
  end

  describe "#update" do
    it "should update successfully" do
      @update_params = {
        user: {
          size: "900"
        },
        id: @user.id,
        format: 'js'
      }
      put :update, @update_params
      expect(User.order(:updated_at).last.size).to eq 900
    end

    it "should not update" do
      last_update = User.order(:updated_at).last.updated_at
      sleep 1
      @bad_params = {
        user: {
          size: "899"
        },
        id: @user.id,
        format: 'js'
      }
      put :update, @bad_params
      expect(User.order(:updated_at).last.updated_at).to eq last_update
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
