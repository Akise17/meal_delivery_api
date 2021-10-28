class BusinessHour < ApplicationRecord
    belongs_to :restaurant, class_name: "Restaurant", foreign_key: "restaurant_id"
end
