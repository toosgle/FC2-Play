require 'spec_helper'

describe User do

  describe 'Association' do
    it { should have_many(:favs) }
    it { should have_many(:histories) }
  end

  describe 'Validation' do
    describe '#name' do
      it 'should be unique' do
        should validate_uniqueness_of(:name)
      end

      it 'should not nil' do
        should validate_presence_of(:name)
      end
    end

    describe '#password' do
      it 'should be same as _confirmation' do
        should validate_confirmation_of(:password)
      end

      it 'should be secure password' do
        should have_secure_password
      end
    end
  end

  describe '#unique?' do
    before(:each) do
      create(:user)
    end

    context 'unique' do
      it 'should return true' do
        u = User.new(name: "testRspecUni", password: "a", password_confirmation: "a")
        expect(u.unique?).to be_truthy
      end
    end

    context 'not unique' do
      it 'should return false' do
        u = User.new(name: "testRspec", password: "a", password_confirmation: "a")
        expect(u.unique?).to be_falsey
      end
    end
  end

end
