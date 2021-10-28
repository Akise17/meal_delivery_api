class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.integer :user_id
      t.string :restaurant_name
      t.string :dish
      t.float :amount
      t.datetime :purchase_date
      t.timestamps
    end
  end
end
