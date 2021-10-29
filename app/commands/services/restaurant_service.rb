module Services
    class RestaurantService
        def self.restaurant_by_open_time(params)
            day = params[:datetime].to_date.strftime("%a")
            time = params[:datetime].to_datetime.strftime("%H:%M:%S")
            q = BusinessHour.where("business_hours.day = ?", day)
                .where("business_hours.open_time <= ?", time)
                .where("business_hours.close_time >= ?", time)
                .ransack(params[:q])

            bussiness_hours = q.result.paginate(:page => params[:page], :per_page => params[:per_page])
            
            data = {
                total: q.result.count, 
                current_page: bussiness_hours.current_page, 
                total_pages:(q.result.count/params[:per_page].to_i)+1, 
                limit: bussiness_hours.per_page,
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

            restaurants = q.limit(params[:per_page]).paginate(:page => params[:page])

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