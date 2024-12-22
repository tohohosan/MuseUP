require 'rails_helper'

RSpec.describe Museum, type: :model do
  describe 'バリデーション' do
    let(:user) { FactoryBot.create(:user) }
    let(:museum) { FactoryBot.build(:museum) }
    let(:category) { FactoryBot.build(:category) }

    it '名前が存在する場合、有効であること' do
      expect(museum).to be_valid
    end

    it '名前が空の場合、無効であること' do
      museum.name = ''
      expect(museum).not_to be_valid
    end

    it '名前が100文字以下の場合、有効であること' do
      museum.name = 'あ' * 100
      expect(museum).to be_valid
    end

    it '名前が100文字より長い場合、無効であること' do
      museum.name = 'あ' * 101
      expect(museum).not_to be_valid
    end

    it '住所が存在する場合、有効であること' do
      expect(museum).to be_valid
    end

    it '住所が空の場合、無効であること' do
      museum.address = ''
      expect(museum).not_to be_valid
    end

    it '説明が存在する場合、有効であること' do
      expect(museum).to be_valid
    end

    it '説明が空の場合、無効であること' do
      museum.description = ''
      expect(museum).not_to be_valid
    end

    it '説明が500文字以内の場合、有効であること' do
      museum.description = 'あ' * 500
      expect(museum).to be_valid
    end

    it '説明が500文字より長い場合、無効であること' do
      museum.description = 'あ' * 501
      expect(museum).not_to be_valid
    end

    it 'URLが正しい形式の場合、有効であること' do
      museum.url = 'http://example.com'
      expect(museum).to be_valid
    end

    it 'URLが不正な形式の場合、無効であること' do
      museum.url = 'invalid-url'
      expect(museum).not_to be_valid
    end

    it 'カテゴリが1つ以上存在する場合、有効であること' do
      expect(museum).to be_valid
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
      5.times do
        uploaded_file = Rack::Test::UploadedFile.new(
          Rails.root.join('spec/fixtures/files/test_image.jpg'), 'image/jpeg'
        )
        museum.images.build(file: uploaded_file)
      end
      museum.save
      expect(museum).not_to be_valid
    end
  end
end
