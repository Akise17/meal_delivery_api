class Restaurant < ApplicationRecord
    has_many :menus, class_name: "Menu", foreign_key: "restaurant_id", :dependent => :destroy
    has_many :bussiness_hours, class_name: "BusinessHour", foreign_key: "restaurant_id", :dependent => :destroy
end
