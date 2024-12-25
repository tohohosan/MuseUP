require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create(:user) }

  describe 'バリデーション' do
    context '有効なユーザー' do
      it '条件が正しい場合、有効であること' do
        expect(user).to be_valid
      end
    end

    context 'ユーザーのバリデーション' do
      it '名前が空の場合、無効であること' do
        user = FactoryBot.build(:user, name: '')
        expect(user).not_to be_valid
      end

      it '名前が50文字より長い場合、無効であること' do
        user.name = 'あ' * 51
        expect(user).not_to be_valid
      end

      it 'メールアドレスが空の場合、無効であること' do
        user = FactoryBot.build(:user, email: '')
        expect(user).not_to be_valid
      end

      it 'メールアドレスが一意であること' do
        user1 = FactoryBot.create(:user, email: 'test@example.com')
        user2 = FactoryBot.build(:user, email: 'test@example.com')
        expect(user2).not_to be_valid
      end

      it 'メールアドレスが正しい形式であること' do
        user = FactoryBot.build(:user, email: 'invalid_email')
        expect(user).not_to be_valid
      end

      it 'パスワードが空の場合、無効であること' do
        user = FactoryBot.build(:user, password: '')
        expect(user).not_to be_valid
      end

      it 'パスワードが 6 文字未満の場合、無効であること' do
        user = FactoryBot.build(:user, password: 'abc', password_confirmation: 'abc')
        expect(user).not_to be_valid
      end
    end
  end

  describe 'アソシエーション' do
    it '複数の museums を持つこと' do
      assoc = User.reflect_on_association(:museums)
      expect(assoc.macro).to eq(:has_many)
    end

    it '複数の reviews を持つこと' do
      assoc = User.reflect_on_association(:reviews)
      expect(assoc.macro).to eq(:has_many)
    end

    it '複数の notes を持つこと' do
      assoc = User.reflect_on_association(:notes)
      expect(assoc.macro).to eq(:has_many)
    end

    it '複数の lists を持つこと' do
      assoc = User.reflect_on_association(:lists)
      expect(assoc.macro).to eq(:has_many)
    end
  end

  describe 'enum' do
    it '役割が general または admin であること' do
      is_expected.to define_enum_for(:role).with_values(general: 0, admin: 1)
    end
  end

  describe 'インスタンスメソッド' do
    it 'デフォルトリストが作成されること' do
      user = FactoryBot.create(:user)
      expect(user.lists.count).to be > 0 # デフォルトリストが存在することを確認
    end
  end

  describe 'Omniauth' do
    let(:auth) do
      OmniAuth::AuthHash.new(
        provider: 'google_oauth2',
        uid: '123456',
        info: { email: 'test@example.com', name: 'Test User' }
      )
    end

    it 'Omniauth 認証でユーザーが作成されること' do
      user = User.from_omniauth(auth)
      expect(user).to be_valid
    end
  end
end
