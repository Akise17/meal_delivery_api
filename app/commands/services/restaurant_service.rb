module Services
    class RestaurantService
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
        
    end
end