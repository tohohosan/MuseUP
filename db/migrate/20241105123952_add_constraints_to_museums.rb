class AddConstraintsToMuseums < ActiveRecord::Migration[7.2]
  def change
    change_column_null :museums, :name, false
    change_column_null :museums, :address, false
    change_column_null :museums, :description, false
    add_index :museums, :name, unique: true
  end
end
