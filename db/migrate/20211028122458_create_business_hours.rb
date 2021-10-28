class CreateBusinessHours < ActiveRecord::Migration[6.1]
  def change
    create_table :business_hours do |t|
      t.integer :restaurant_id
      t.string :day
      t.string :open_time
      t.string :close_time
      t.timestamps
    end
  end
end
