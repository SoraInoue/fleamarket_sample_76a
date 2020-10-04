class CreateDestinations < ActiveRecord::Migration[5.2]
  def change
    create_table :destinations do |t|

      t.string :destination_family_name, null: false
      t.string :destination_first_name, null: false
      t.string :destination_family_name_kana, null: false
      t.string :destination_first_name_kana, null: false
      t.string :postal_code, null: false
      t.integer :prefecture_id, null: false
      t.string :city, null: false
      t.string :street_block, null: false
      t.string :mansion_name
      t.integer :user_id, null: false, foreign_key: true
      t.string :nickname, null: false
      t.string :icon
      t.text :introduction
      t.timestamps
    end
  end
end