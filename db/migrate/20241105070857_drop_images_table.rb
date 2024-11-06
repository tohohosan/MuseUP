class DropImagesTable < ActiveRecord::Migration[7.2]
  def up
    drop_table :images
  end

  def down
    create_table :images do |t|
      t.references :user, null: false, foreign_key: true
      t.references :museum, null: false, foreign_key: true
      t.string :image
      t.timestamps
    end
  end
end
