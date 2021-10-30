module Services
    class UserServices
        def self.import_user
            user_lists = JSON.parse(File.read('./storage/users.json'))

            user_lists.each do |user_list|
                @user = User.create(
                    name: user_list["name"],
                    username: user_list["name"].gsub(" ","_"),
                    password: "hungry12345678",
                    location: user_list["location"],
                    balance: user_list["balance"]
                    # purchases_attributes: user_list["purchase_attributes"]
                )
                @user.transactions.create(user_list["purchases_attributes"])

                Services::EcsService.index("users", @user.as_json(:include => [:purchases_attributes]))
            end

            Handler::Res.call(201, "Import Success.", nil)
        end

        def self.import_restaurant
            resto_lists = JSON.parse(File.read('./storage/restaurants.json'))

            resto_lists.each do |resto_list|
                location = resto_list["location"].split(",")
                @resto = Restaurant.create(
                    name: resto_list["name"],
                    location: resto_list["location"],
                    balance: resto_list["balance"],
                    latitude: location[0],
                    longitude: location[1]
                )

                unless resto_list["business_hours"].nil?
                    days = resto_list["business_hours"].split("|")
                    puts "Days: #{days}"
                    bussiness_hours = []
                    days.each do |day|
                        d = day.gsub(": ","#").gsub(" - ","#").gsub(" ","").split(/#| - /)
                        multi_days = d[0].split(/-|,/)
                        if multi_days.length > 1
                            multi_days.each do |multi_day|
                                data = {
                                    day: filter_day(multi_day),
                                    open_time: begin Time.strptime(d[1], "%I:%M%P").strftime("%H:%M") rescue Time.strptime(d[1], "%I%P").strftime("%H:%M") end, 
                                    close_time: begin Time.strptime(d[2], "%I:%M%P").strftime("%H:%M") rescue Time.strptime(d[2], "%I%P").strftime("%H:%M") end
                                }
                                bussiness_hours.push(data)
                            end
                        else
                            data = {
                                day: filter_day(d[0]),
                                open_time: begin Time.strptime(d[1], "%I:%M%P").strftime("%H:%M") rescue Time.strptime(d[1], "%I%P").strftime("%H:%M") end, 
                                close_time: begin Time.strptime(d[2], "%I:%M%P").strftime("%H:%M") rescue Time.strptime(d[2], "%I%P").strftime("%H:%M") end
                            }
                            bussiness_hours.push(data)
                        end
                    end
                    @resto.bussiness_hours.create(bussiness_hours)

                end
                
                @resto.menus.create(resto_list["menu"])

                Services::EcsService.index("restaurants", @resto.as_json(:include => [:menus, :bussiness_hours]))
            end
            Handler::Res.call(201, "Import Success.", [])
        end

        def self.top_user_by_transaction_amount(params)
            q = User.joins(:transactions)
                .select('users.id, users.name, users.location, sum(transactions.amount) as total_amount')
                .where("transactions.purchase_date BETWEEN ? AND ?", params[:start_date], params[:end_date])
                .group('id')
                .order('total_amount DESC')

            users = q.paginate(page: params[:page], per_page: params[:per_page])

            data = {
                total: q.length, 
                current_page: params[:page], 
                total_pages:(q.length/params[:per_page].to_i)+1, 
                limit: params[:per_page],
                users: users.as_json
            }
            Handler::Res.call(200, "Retrive data successful.", data)
        end

        def self.my_transaction(current_api_user)
            user = current_api_user
            Handler::Res.call(200, "Retrive data successful.", user.as_json(:include => [:transactions]))
        end
        

        private

        def self.filter_day(word)
            return word.gsub("Thur","Thu")
                .gsub("Sunday","Sun")
                .gsub("Monday","Mon")
                .gsub("Tuesday","Tue")
                .gsub("Tues","Tue")
                .gsub("Wednesday","Wed")
                .gsub("Weds","Wed")
                .gsub("Thursday","Thu")
                .gsub("Thurs","Thu")
                .gsub("Thusday","Thu")
                .gsub("Friday","Fri")
                .gsub("Saturday","Sat")
        end
    end
end