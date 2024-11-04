class CreateMuseumCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :museum_categories do |t|
      t.references :museum, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
