Rails.application.routes.draw do
  namespace :api, defaults: {format: :json} do 
    namespace :v1 do
      post  "/import_user", to: "user#import_user"
      post  "/import_restaurant", to: "user#import_restaurant"

      get "/restaurant/open", to: "restaurant#restaurant_by_open_time" #ok
      get "/restaurant/distance", to: "restaurant#restaurant_by_distance" #ok
      get "/restaurant/time_range", to: "restaurant#restaurant_by_open_time_range" #ok
      get "/restaurant/price_range", to: "restaurant#restaurant_by_price_range" #ok
      get "/restaurant/search", to: "restaurant#search" #ok
      get "/restaurant/top_restaurant", to: "restaurant#popular_restaurant" #ok
      get "/restaurant/transaction/:id", to: "restaurant#restaurant_transaction" #ok

      get "/user/top_user", to: "user#top_user_by_transaction_amount" #ok
      get "/user/transaction", to: "user#my_user_transaction" #ok

      post "/order", to: "user#create_transaction" #ok
    end
  end
end
