class CreateCreditcards < ActiveRecord::Migration[5.2]
  def change
    create_table :creditcards do |t|

      t.string :user_id
      t.string :customer_id
      t.string :card_id


      t.timestamps
    end
  end
end
