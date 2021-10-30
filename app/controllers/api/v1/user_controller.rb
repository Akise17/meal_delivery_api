class Api::V1::UserController < Api::ApplicationController
    def import_user
        users = Services::UserServices.import_user
        render json:users.as_json, status: users[:meta][:status]
    end
    
    def import_restaurant
        resto = Services::UserServices.import_restaurant
        render json:resto.as_json, status: resto[:meta][:status]
    end

    def top_user_by_transaction_amount
        users = Services::UserServices.top_user_by_transaction_amount(params)
        render json:users.as_json, status: users[:meta][:status]
    end

    def my_transaction
        users = Services::UserServices.my_transaction(@current_api_user)
        render json:users.as_json, status: users[:meta][:status]
    end
    
    
    def test
        render json:{
            user: @current_api_user.as_json
        }
    end
    
end
