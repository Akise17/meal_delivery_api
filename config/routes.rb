Rails.application.routes.draw do
  namespace :api, defaults: {format: :json} do 
    namespace :v1 do
      post "/test", to: "user#test"
      post  "/import_user", to: "user#import_user"
      post  "/import_restaurant", to: "user#import_restaurant"

      get "/restaurant/open", to: "restaurant#restaurant_by_open_time"
      get "/restaurant/distance", to: "restaurant#restaurant_by_distance"
      get "/restaurant/time_range", to: "restaurant#restaurant_by_open_time_range"
      get "/restaurant/price_range", to: "restaurant#restaurant_by_price_range"
      get "/restaurant/search", to: "restaurant#search"

      get "/user/top_user", to: "user#top_user_by_transaction_amount"
    end
  end
end
