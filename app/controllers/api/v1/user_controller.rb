class Api::V1::UserController < Api::ApplicationController
    def import_user
        user = Services::UserServices.import_user
        render json:user.as_json, status: user[:meta][:status]
    end
    
    def import_restaurant
        resto = Services::UserServices.import_restaurant
        render json:resto.as_json, status: resto[:meta][:status]
    end
    
    def test
        render json:{
            user: @current_api_user.as_json
        }
    end
    
end
