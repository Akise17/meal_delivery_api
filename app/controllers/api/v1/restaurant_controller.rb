class Api::V1::RestaurantController < Api::ApplicationController
    def restaurant_by_open_time
        restaurants = Services::RestaurantService.restaurant_by_open_time(params)
        render json: restaurants.as_json, status: restaurants[:meta][:status]
    end
    
    def restaurant_by_distance
        restaurants = Services::RestaurantService.restaurant_by_distance(params)
        render json: restaurants.as_json, status: restaurants[:meta][:status]
    end
    
end
