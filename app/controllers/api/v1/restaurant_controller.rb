class Api::V1::RestaurantController < Api::ApplicationController

    def import_restaurant
        restaurants = Services::RestaurantServices.import_restaurant
        render json:restaurants.as_json, status: restaurants[:meta][:status]
    end

    def restaurant_by_open_time
        params.require([:per_page,:page])
        restaurants = Services::RestaurantService.restaurant_by_open_time(params)
        render json: restaurants.as_json, status: restaurants[:meta][:status]
        
    end
    
    def restaurant_by_distance
        params.require([:per_page,:page, :distance, :location])
        restaurants = Services::RestaurantService.restaurant_by_distance(params)
        render json: restaurants.as_json, status: restaurants[:meta][:status]
    end

    def restaurant_by_open_time_range
        params.require([:per_page,:page, :open_time, :close_time])
        restaurants = Services::RestaurantService.restaurant_by_open_time_range(params)
        render json: restaurants.as_json, status: restaurants[:meta][:status]
    end

    def restaurant_by_price_range
        params.require([:per_page,:page, :price_range])
        restaurants = Services::RestaurantService.restaurant_by_price_range(params)
        render json: restaurants.as_json, status: restaurants[:meta][:status]
    end

    def search
        params.require([:per_page,:page, :keyword, :filter])
        restaurants = Services::RestaurantService.search(params)
        render json: restaurants.as_json, status: restaurants[:meta][:status]
    end

    def popular_restaurant
        params.require([:per_page,:page])
        restaurants = Services::RestaurantService.popular_restaurant(params)
        render json: restaurants.as_json, status: restaurants[:meta][:status]
    end
    
    def restaurant_transaction
        restaurants = Services::RestaurantService.restaurant_transaction(params)
        render json: restaurants.as_json, status: restaurants[:meta][:status]
    end

    private

    # def page_params
        
    # end
    
end
