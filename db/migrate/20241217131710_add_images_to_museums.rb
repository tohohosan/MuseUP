class AddImagesToMuseums < ActiveRecord::Migration[7.2]
  def change
    add_column :museums, :images, :string, array: true, default: []
  end
end
