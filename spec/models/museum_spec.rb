require 'rails_helper'

RSpec.describe Museum, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:museum) { FactoryBot.build(:museum) }
  let(:category) { FactoryBot.build(:category) }

  let(:uploaded_file) do
    Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/test_image.jpg'), 'image/jpeg')
  end

  describe 'バリデーション' do
    context '有効なミュージアム' do
      it '条件が正しい場合、有効であること' do
        expect(museum).to be_valid
      end
    end

    context 'ミュージアムのバリデーション' do
      it '名前が空の場合、無効であること' do
        museum.name = ''
        expect(museum).not_to be_valid
      end

      it '名前が100文字より長い場合、無効であること' do
        museum.name = 'あ' * 101
        expect(museum).not_to be_valid
      end

      it '住所が空の場合、無効であること' do
        museum.address = ''
        expect(museum).not_to be_valid
      end

      it '説明が空の場合、無効であること' do
        museum.description = ''
        expect(museum).not_to be_valid
      end

      it '説明が500文字より長い場合、無効であること' do
        museum.description = 'あ' * 501
        expect(museum).not_to be_valid
      end

      it 'URLが不正な形式の場合、無効であること' do
        museum.url = 'invalid-url'
        expect(museum).not_to be_valid
      end

      it 'カテゴリが存在しない場合、無効であること' do
        museum.categories = []
        expect(museum).not_to be_valid
      end

      it '画像が4枚以下の場合、有効であること' do
        museum.save!
        expect(museum).to be_valid
      end

      it '画像が5枚以上の場合、無効であること' do
        museum.save!

        5.times do
          museum.images.create!(file: uploaded_file)
        end

        expect(museum).not_to be_valid
        expect(museum.errors[:images]).to include('画像は最大4枚までアップロードできます')
      end
    end
  end

  describe 'アソシエーション' do
    it 'ユーザーに属していること' do
      assoc = Museum.reflect_on_association(:user)
      expect(assoc.macro).to eq(:belongs_to)
    end

    it '複数のカテゴリーを持つこと' do
      assoc = Museum.reflect_on_association(:categories)
      expect(assoc.macro).to eq(:has_many)
    end

    it '複数のイメージを持つこと' do
      assoc = Museum.reflect_on_association(:images)
      expect(assoc.macro).to eq(:has_many)
    end

    it '複数のレビューを持つこと' do
      assoc = Museum.reflect_on_association(:reviews)
      expect(assoc.macro).to eq(:has_many)
    end

    it '複数の list_museums を持つこと' do
      assoc = Museum.reflect_on_association(:list_museums)
      expect(assoc.macro).to eq(:has_many)
    end

    it '複数のリストを持つこと' do
      assoc = Museum.reflect_on_association(:lists)
      expect(assoc.macro).to eq(:has_many)
    end

    it '複数のノートを持つこと' do
      assoc = Museum.reflect_on_association(:notes)
      expect(assoc.macro).to eq(:has_many)
    end
  end
end
