require 'rails_helper'

RSpec.describe Fc2 do
  describe '#scrape' do
    it 'should scrape videos' do
      Fc2.scrape('adult', 10_000, 10_001)
      expect(Video.count > 0).to be_truthy
    end
  end

  describe '#create_50_records' do
  end

  describe '#scrape_params' do
  end

  describe '#video_exists_on_fc2' do
  end
end
