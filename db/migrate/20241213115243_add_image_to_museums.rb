class AddImageToMuseums < ActiveRecord::Migration[7.2]
  def change
    add_column :museums, :image, :string
  end
end
