require 'rails_helper'

RSpec.describe Note, type: :model do
    let(:user) { FactoryBot.create(:user) }
    let(:museum) { FactoryBot.build(:museum) }
    let(:note) { FactoryBot.build(:note, user: user, museum: museum) }

    describe 'バリデーション' do
        context '有効なメモ' do
            it '内容が正しい場合、有効であること' do
                expect(note).to be_valid
            end
        end

        context 'メモのバリデーション' do
            it '内容が空の場合、無効であること' do
                note.content = ''
                expect(note).not_to be_valid
            end

            it '内容が1000文字より長い場合、無効であること' do
                note.content = 'あ' * 1001
                expect(note).not_to be_valid
            end
        end
    end

    describe 'アソシエーション' do
        it 'ユーザーに属していること' do
            assoc = Note.reflect_on_association(:user)
            expect(assoc.macro).to eq(:belongs_to)
        end

        it 'ミュージアムに属していること' do
            assoc = Note.reflect_on_association(:museum)
            expect(assoc.macro).to eq(:belongs_to)
        end
    end
end
