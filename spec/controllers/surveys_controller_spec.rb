require 'spec_helper'

describe SurveysController, :type => :controller do

  describe "#new" do
    it "has a 200 status code" do
      get :new
      expect(response.code).to eq("200")
    end
  end

  describe "#create" do
    context "receive valid params" do
      let(:params) {
        { survey: { result: 1 } }
      }

      it "should create new survey" do
        expect{
          post :create, params
        }.to change(Survey, :count).by(1)
      end

      it "should redirect to root" do
        post :create, params
        expect(response).to redirect_to root_path
      end
    end

    context "receive bad params" do
      let(:bad_params) {
        { survey: { result: nil } }
      }
      
      it "should not create new survey" do
        expect{
          post :create, bad_params
        }.to change(Survey, :count).by(0)
      end

      it "should redirect to root" do
        post :create, bad_params
        expect(response).to render_template(:new)
      end
    end
  end

end
