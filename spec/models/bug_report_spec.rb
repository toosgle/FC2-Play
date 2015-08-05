require 'rails_helper'

RSpec.describe BugReport do
  describe 'Validation' do
    it { should validate_presence_of(:content) }
  end
end
