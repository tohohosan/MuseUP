class CreateMuseums < ActiveRecord::Migration[7.2]
  def change
    create_table :museums do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :address
      t.float :latitude
      t.float :longitude
      t.text :description

      t.timestamps
    end
  end
end
