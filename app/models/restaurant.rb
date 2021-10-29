class Restaurant < ApplicationRecord
    has_many :menus, class_name: "Menu", foreign_key: "restaurant_id", :dependent => :destroy
    has_many :bussiness_hours, class_name: "BusinessHour", foreign_key: "restaurant_id", :dependent => :destroy

    def self.open_time(bussiness_hours_params)
        has_many :selected_hours, -> { 
            where("? BETWEEN open_time AND close_time", bussiness_hours_params[:open_time])
            .where("? BETWEEN open_time AND close_time", bussiness_hours_params[:close_time])
        } , class_name: "BusinessHour", foreign_key: "restaurant_id", :dependent => :destroy
    end

    def self.select_menu(prices)
        has_many :selected_menus, -> { 
            where("price BETWEEN ? AND ?", prices[0], prices[1])
        } , class_name: "Menu", foreign_key: "restaurant_id", :dependent => :destroy
    end
    geocoded_by :address
end
