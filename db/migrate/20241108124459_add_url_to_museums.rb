class AddUrlToMuseums < ActiveRecord::Migration[7.2]
  def change
    add_column :museums, :url, :string
  end
end
