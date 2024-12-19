class CreateImages < ActiveRecord::Migration[7.2]
  def change
    create_table :images do |t|
      t.string :file
      t.references :museum, null: false, foreign_key: true
      t.timestamps
    end
  end
end
