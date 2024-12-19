class RemoveImagesFromMuseum < ActiveRecord::Migration[7.2]
  def change
    remove_column :museums, :images, :string
  end
end
