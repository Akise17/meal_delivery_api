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
            end

            Handler::Res.call(201, "Import Success.", nil)
        end

        def self.import_restaurant
            resto_lists = JSON.parse(File.read('./storage/restaurant.json'))

            resto_lists.each do |resto_list|
                @user = User.create(
                    name: resto_list["name"],
                    username: resto_list["name"].gsub(" ","_"),
                    password: "hungry12345678",
                    location: resto_list["location"],
                    balance: resto_list["balance"]
                )
                @user.transactions.create(resto_list["purchases_attributes"])
            end

            Handler::Res.call(201, "Import Success.", nil)
        end
        
    end
end