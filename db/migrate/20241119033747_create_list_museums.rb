class CreateListMuseums < ActiveRecord::Migration[7.2]
  def change
    create_table :list_museums do |t|
      t.references :list, null: false, foreign_key: true
      t.references :museum, null: false, foreign_key: true

      t.timestamps
    end
  end
end
