require 'rails_helper'

RSpec.describe Review, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:museum) { FactoryBot.build(:museum) }
  let(:review) { FactoryBot.build(:review, user: user, museum: museum) }

  describe 'バリデーション' do
    context '有効なレビュー' do
      it '内容とレーティングが正しい場合、有効であること' do
        expect(review).to be_valid
      end
    end

    context 'レビューのバリデーション' do
      it '内容が空の場合、無効であること' do
        review.content = ''
        expect(review).not_to be_valid
      end

      it '内容が500文字以上の場合、無効であること' do
        review.content = 'あ' * 501
        expect(review).not_to be_valid
      end

      it 'レーティングが空の場合、無効であること' do
        review.rating = nil
        expect(review).not_to be_valid
      end

      it 'レーティングが範囲外の場合、無効であること' do
        review.rating = 6
        expect(review).not_to be_valid
      end
    end
  end

  describe 'アソシエーション' do
    it 'ユーザーに属していること' do
      assoc = Review.reflect_on_association(:user)
      expect(assoc.macro).to eq(:belongs_to)
    end

    it 'ミュージアムに属していること' do
      assoc = Review.reflect_on_association(:museum)
      expect(assoc.macro).to eq(:belongs_to)
    end
  end
end
