require 'spec_helper'

describe FavsController, :type => :controller do

  before(:each) do
    @user = create(:user)
    session[:user_id] = @user.id
    @fav = create(:fav1, user_id: @user.id)
    @fav.save
  end

  describe "#create" do
    it "should create new fav" do
      @create_params = {
        fav: {
          video_id: "10001001",
          comment: "abcde"
        },
        format: 'js'
      }
      expect{
        post :create, @create_params
      }.to change(Fav, :count).by(1)
    end

    it "has a 200 status code" do
      @create_params = {
        fav: {
          video_id: "10001001",
          comment: "abcde"
        },
        format: 'js'
      }
      post :create, @create_params
      expect(response.code).to eq("200")
    end

    context "already has 100 favs" do
      it "should fail to create new fav" do
        100.times { create(:fav, user_id: @user.id) }
        @create_params = {
          fav: {
            video_id: "99999999",
            comment: "abcde"
          },
          format: 'js'
        }
        expect{
          post :create, @create_params
        }.to change(Fav, :count).by(0)
      end
    end

    context "bad_params" do
      it "should fail to create new fav" do
        100.times { create(:fav, user_id: @user.id) }
        @bad_create_params = {
          fav: {
            comment: "abcde"
          },
          format: 'js'
        }
        expect{
          post :create, @bad_create_params
        }.to change(Fav, :count).by(0)
      end
    end

    context "the bookmark has already exist" do
      it "should fail to create new fav" do
        @bad_create_params = {
          fav: {
            video_id: "10001000",
            comment: "abcde"
          },
          format: 'js'
        }
        expect{
          post :create, @bad_create_params
        }.to change(Fav, :count).by(0)
      end
    end
  end

  describe "#update" do
    it "should update successfully" do
      @update_params = {
        fav: {
          video_id: "10001000",
          comment: "updated"
        },
        id: @fav.id,
        format: 'js'
      }
      put :update, @update_params
      expect(Fav.order(:updated_at).last.comment).to eq "updated"
    end

    it "has 200 status code" do
      @update_params = {
        fav: {
          video_id: "10001000",
          comment: "updated"
        },
        id: @fav.id,
        format: 'js'
      }
      put :update, @update_params
      expect(response.code).to eq "200"
    end

    it "should not update" do
      last_update = Fav.order(:updated_at).last.updated_at
      sleep 1
      @bad_params = {
        fav: {
          video_id: nil,
          comment: "updated"
        },
        id: @fav.id,
        format: 'js'
      }
      put :update, @bad_params
      expect(Fav.order(:updated_at).last.updated_at).to eq last_update
    end
  end

  describe "#destroy" do
    it "should destroy successfully" do
      expect{
        delete :destroy, {:id => @fav.id, format: 'js'}
      }.to change(Fav, :count).by(-1)
    end

    it "has 200 status code" do
      delete :destroy, {:id => @fav.id, format: 'js'}
      expect(response.code).to eq "200"
    end

    it "should not destroy successfully" do
      others_fav = create(:fav, user_id: @user.id+1)
      expect{
        delete :destroy, {:id => others_fav.id, format: 'js'}
      }.to change(Fav, :count).by(0)
    end
  end

end
