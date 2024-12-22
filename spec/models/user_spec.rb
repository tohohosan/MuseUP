require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    let(:user) { FactoryBot.create(:user) }

    it '名前が存在する場合、有効であること' do
      expect(user).to be_valid
    end

    it '名前が空の場合、無効であること' do
      user = FactoryBot.build(:user, name: '')
      expect(user).not_to be_valid
    end

    it 'メールアドレスが存在する場合、有効であること' do
      expect(user).to be_valid
    end

    it 'メールアドレスが空の場合、無効であること' do
      user = FactoryBot.build(:user, email: '')
      expect(user).not_to be_valid
    end

    it 'パスワードが存在する場合、有効であること' do
      expect(user).to be_valid
    end

    it 'パスワードが空の場合、無効であること' do
      user = FactoryBot.build(:user, password: '')
      expect(user).not_to be_valid
    end

    it 'パスワードが 6 文字以上の場合、有効であること' do
      expect(user).to be_valid
    end

    it 'パスワードが 6 文字未満の場合、無効であること' do
      user = FactoryBot.build(:user, password: 'abc', password_confirmation: 'abc')
      expect(user).not_to be_valid
    end
  end
end
