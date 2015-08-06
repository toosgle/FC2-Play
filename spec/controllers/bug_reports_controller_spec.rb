require 'rails_helper'

RSpec.describe BugReportsController, type: :controller do
  describe '#create' do
    let(:params) do
      {
        content: content,
        format: 'js'
      }
    end

    context 'valid params' do
      let(:content) { 'bug report comment' }

      it 'should create new fav' do
        expect do
          post :create, params
        end.to change(BugReport, :count).by(1)
      end
    end

    context 'invalid params' do
      let(:content) { nil }

      it 'should not create new fav' do
        expect do
          post :create, params
        end.to change(BugReport, :count).by(0)
      end
    end
  end
end
