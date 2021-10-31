class AddLatLong < ActiveRecord::Migration[6.1]
  def change
    add_column :restaurants, :latitude, :float, :default => 0
    add_column :restaurants, :longitude, :float, :default => 0
    
    add_index :restaurants, [:latitude, :longitude]
    #Ex:- add_index("admin_users", "username")
  end
end
