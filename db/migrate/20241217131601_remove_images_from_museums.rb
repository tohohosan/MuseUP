class RemoveImagesFromMuseums < ActiveRecord::Migration[7.2]
  def change
    remove_column :museums, :images
  end
end
