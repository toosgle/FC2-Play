require 'spec_helper'

describe BugReportsController, :type => :controller do

  describe "#create" do
    let(:params) {
      {
        content: "bug report comment",
        format: 'js'
      }
    }

    it "should create new fav" do
      expect{
        post :create, params
      }.to change(BugReport, :count).by(1)
    end

    it "should not create new fav" do
      params[:content] = nil
      expect{
        post :create, params
      }.to change(BugReport, :count).by(0)
    end
  end

end
