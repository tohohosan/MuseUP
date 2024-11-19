class AddDefaultToLists < ActiveRecord::Migration[7.2]
  def change
    add_column :lists, :default, :boolean, null: false, default: false
  end
end
