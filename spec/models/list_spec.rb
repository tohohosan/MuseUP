require 'rails_helper'

RSpec.describe List, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:list) { FactoryBot.build(:list, user: user) }

  describe 'バリデーション' do
    context '有効なリスト' do
      it 'リスト名とユーザーが存在する場合、有効であること' do
        expect(list).to be_valid
      end
    end

    context 'リスト名のバリデーション' do
      it 'リスト名が空の場合、無効であること' do
        list.name = ''
        expect(list).not_to be_valid
        expect(list.errors[:name]).to include("を入力してください")
      end

      it '同じユーザー内でリスト名が重複する場合、無効であること' do
        FactoryBot.create(:list, user: user, name: '重複リスト')
        duplicate_list = FactoryBot.build(:list, user: user, name: '重複リスト')
        expect(duplicate_list).not_to be_valid
        expect(duplicate_list.errors[:name]).to include('はすでに存在します')
      end

      it '異なるユーザーで同じ名前のリストは作成できること' do
        other_user = FactoryBot.create(:user) # 別のユーザーを作成
        FactoryBot.create(:list, user: other_user, name: '重複リスト')
        expect(list).to be_valid # 同じ名前でも別のユーザーなら有効
      end
    end
  end

  describe 'デフォルトリストの制限' do
    let(:default_list) { FactoryBot.create(:list, user: user, default: true, name: 'デフォルトリスト') }

    it 'デフォルトリストは名前を変更できないこと' do
      default_list.name = '新しい名前'
      expect(default_list.save).to be false # 名前変更は失敗する
    end

    it 'デフォルトリストではない場合、名前を変更できること' do
      non_default_list = FactoryBot.create(:list, user: user, default: false, name: '普通リスト')
      non_default_list.name = '変更されたリスト'
      expect(non_default_list.save).to be true # 名前変更は成功する
    end
  end

  describe 'アソシエーション' do
    it 'ユーザーに属していること' do
      assoc = List.reflect_on_association(:user)
      expect(assoc.macro).to eq(:belongs_to)
    end

    it '複数の list_museums を持つこと' do
      assoc = List.reflect_on_association(:list_museums)
      expect(assoc.macro).to eq(:has_many)
    end

    it '複数の museums を持つこと' do
      assoc = List.reflect_on_association(:museums)
      expect(assoc.macro).to eq(:has_many)
    end
  end
end
