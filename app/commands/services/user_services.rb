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

        def self.my_user_transaction(current_api_user)
            user = current_api_user
            Handler::Res.call(200, "Retrive data successful.", user.as_json(:include => [:transactions]))
        end

        def self.create_transaction(current_api_user, params)
            user = current_api_user
            menu = Menu.find(params[:menu_id])

            transaction = current_api_user.transactions.new(
                restaurant_name: menu.restaurant.name,
                dish: menu.name,
                amount: menu.price,
                purchase_date: DateTime.now.strftime("%Y-%m-%d %H:%M:%S")
            )

            if transaction.save
                user.update(
                    balance: user.balance - transaction.amount
                )
                
                Handler::Res.call(201, "Transaction success.", transaction.as_json(:include => [:user]))
            end
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