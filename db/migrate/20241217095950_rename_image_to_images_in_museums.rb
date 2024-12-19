class RenameImageToImagesInMuseums < ActiveRecord::Migration[7.2]
  def up
    # 一時カラムの追加
    add_column :museums, :images_temp, :json, default: []

    # データを一時カラムに移行
    execute <<~SQL
      UPDATE museums SET images_temp = to_json(ARRAY[image])
    SQL

    # 元のカラムを削除して新しいカラムに置き換える
    remove_column :museums, :image
    rename_column :museums, :images_temp, :images
  end

  def down
    # 復元用のカラムを追加
    add_column :museums, :image, :string

    # 配列型を JSON 型にキャストして文字列として復元
    execute <<~SQL
      UPDATE museums
      SET image = (
        SELECT string_agg(element, ',')
        FROM unnest(images) AS element
      )
    SQL

    # 新しいカラムを削除
    remove_column :museums, :images
  end
end
