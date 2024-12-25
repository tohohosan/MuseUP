class List < ApplicationRecord
  belongs_to :user
  has_many :list_museums, dependent: :destroy
  has_many :museums, through: :list_museums

  validates :name, presence: true, length: { maximum: 50 }
  validates :name, uniqueness: { scope: :user_id }

  # デフォルトリストの名前変更を禁止
  before_update :prevent_default_list_changes, if: :default?

  private

  def prevent_default_list_changes
    throw(:abort) if name_changed?
  end
end
