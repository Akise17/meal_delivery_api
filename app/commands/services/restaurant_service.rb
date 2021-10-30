module Services
    class RestaurantService
        require 'elasticsearch/model'

        def self.restaurant_by_open_time(params)
            day = params[:datetime].to_date.strftime("%a")
            time = params[:datetime].to_datetime.strftime("%H:%M:%S")
            q = BusinessHour.where("business_hours.day = ?", day)
                .where("business_hours.open_time <= ?", time)
                .where("business_hours.close_time >= ?", time)

            bussiness_hours = q.paginate(page: params[:page], per_page: params[:per_page])
            
            data = {
                total: q.length, 
                current_page: params[:page], 
                total_pages:(q.length/params[:per_page].to_i)+1, 
                limit: params[:per_page],
                datetime: params[:datetime],
                bussiness_hours: bussiness_hours.as_json(
                    :include => [
                        :restaurant => {:except => [:created_at, :updated_at]}
                    ],
                    :except => [:restaurant_id, :created_at, :updated_at]
                )    
            }

            Handler::Res.call(200, "Success retrive data", data)
        end

        def self.restaurant_by_distance(params)
            location = params[:location].split(",")
            q = Restaurant.near(location, params[:distance])

            restaurants = q.paginate(page: params[:page], per_page: params[:per_page])

            data = {
                total: q.length, 
                current_page: params[:page], 
                total_pages:(q.length/params[:per_page].to_i)+1, 
                limit: params[:per_page],
                restaurant: restaurants.as_json
            }
            Handler::Res.call(200, "Success retrive data", data)
        end

        def self.restaurant_by_open_time_range(params)
            q = Restaurant.joins(:bussiness_hours)
                .where("? BETWEEN open_time AND close_time", params[:open_time])
                .where("? BETWEEN open_time AND close_time", params[:close_time])
                .group("id")
            
            restaurants = q.paginate(page: params[:page], per_page: params[:per_page])
                
            restaurants.open_time(params)

            data = {
                total: q.length, 
                current_page: params[:page], 
                total_pages:(q.length/params[:per_page].to_i)+1, 
                limit: params[:per_page],
                restaurant: restaurants.as_json(:include => [:selected_hours])
            }
            Handler::Res.call(200, "Success retrive data", data)
        end
        
        def self.restaurant_by_price_range(params)
            prices = params[:price_range].split("-")
            q = Restaurant.joins(:menus)
                .where("menus.price BETWEEN ? AND ?", prices[0], prices[1])
                .group("id")

            restaurants = q.paginate(page: params[:page], per_page: params[:per_page])
            
            restaurants.select_menu(prices)

            data = {
                total: q.length, 
                current_page: params[:page], 
                total_pages:(q.length/params[:per_page].to_i)+1, 
                limit: params[:per_page],
                restaurant: restaurants.as_json(:include => [:selected_menus])
            }
            Handler::Res.call(200, "Success retrive data", data)
        end

        def self.search(params)

            if params[:filter] == "relevance"
                body = {
                    "from": params[:page],
                    "size": params[:per_page],
                    "sort": ["_score": "desc"], 
                    "query": { 
                        "bool": { 
                            "must": [],
                            "filter": [],
                            "should": [
                                {
                                    "bool":{
                                        "should": ["match":{"name": params[:keyword]}]
                                    }
                                },
                                {
                                    "bool":{
                                        "should": ["match":{"menus.name": params[:keyword]}]
                                    }
                                }
                            ],
                            "must_not": [] 
                        }
                    }
                }
            elsif params[:filter] == "best_match"
                body = {
                    "from": params[:page],
                    "size": params[:per_page],
                    "sort": ["_score": "desc"], 
                    "query": { 
                      "bool": { 
                        "must": [],
                        "filter": [],
                        "should": [
                            {
                                "bool":{
                                    "should": ["match_phrase":{"name": params[:keyword]}]
                                }
                            },
                            {
                                "bool":{
                                    "should": ["match_phrase":{"menus.name": params[:keyword]}]
                                }
                            }
                        ],
                        "must_not": [] 
                      }
                    }
                  }
            end

            puts body.as_json

            q = Restaurant.__elasticsearch__.search(body)

            data = {
                total: q.results.total, 
                current_page: params[:page], 
                total_pages:((q.results.total)/params[:per_page].to_i)+1, 
                limit: params[:per_page],
                restaurants: q.as_json
            }

            Handler::Res.call(200, "Success retrive data", data)
        end
       
        def self.popular_restaurant(params)
            q = Restaurant.joins("RIGHT JOIN transactions ON restaurants.name = transactions.restaurant_name")
                .select('restaurants.id, restaurants.name, count(transactions.id) as transactions_count, sum(transactions.amount) as total_amount')
                .group('restaurants.name')
                .order('transactions_count DESC, total_amount DESC')

            restaurants = q.paginate(page: params[:page], per_page: params[:per_page])

            data = {
                total: q.length, 
                current_page: params[:page], 
                total_pages:(q.length/params[:per_page].to_i)+1, 
                limit: params[:per_page],
                restaurant: restaurants.as_json
            }
            Handler::Res.call(200, "Success retrive data", data)
        end
        
    end
end