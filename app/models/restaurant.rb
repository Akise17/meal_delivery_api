class Restaurant < ApplicationRecord
    has_many :menus, class_name: "Menu", foreign_key: "restaurant_id", :dependent => :destroy
    has_many :bussiness_hours, class_name: "BusinessHour", foreign_key: "restaurant_id", :dependent => :destroy

    def self.open_time(bussiness_hours_params)
        puts "open_time #{bussiness_hours_params[:open_time]}"
        puts "close_time #{bussiness_hours_params[:close_time]}" 
        has_many :selected_hours, -> { 
            where("? BETWEEN open_time AND close_time", bussiness_hours_params[:open_time])
            .where("? BETWEEN open_time AND close_time", bussiness_hours_params[:close_time])
        } , class_name: "BusinessHour", foreign_key: "restaurant_id", :dependent => :destroy
    end

    puts "open_time outside #{@open_time}"
    puts "close_time outside #{@close_time}" 

    #  has_many :selected_hours, -> { 
    #     where("? BETWEEN open_time AND close_time", @open_time)
    #     .where("? BETWEEN open_time AND close_time", @close_time)
    # } , class_name: "BusinessHour", foreign_key: "restaurant_id", :dependent => :destroy
    geocoded_by :address
end
