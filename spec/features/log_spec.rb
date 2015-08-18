require 'rails_helper'
include DataHelper

RSpec.describe HomeController, type: :feature do
  before(:each) do
    create_base_data
  end

  describe 'check fc2play version' do
    it 'log should be save version as top page' do
      visit '/log'
      log_ver = find("//*[@id='wrapper']/div[2]/ul/li[2]/div/div[1]/h4").text

      visit '/'
      top_ver = find("//*[@id='wrapper']/center/font/p/a").text

      expect(log_ver).to eq(top_ver)
    end
  end
end
