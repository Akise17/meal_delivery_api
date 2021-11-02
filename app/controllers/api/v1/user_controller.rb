class Api::V1::UserController < Api::ApplicationController
    def import_user
        users = Services::UserServices.import_user
        render json:users.as_json, status: users[:meta][:status]
    end

    def top_user_by_transaction_amount
        params.require([:per_page,:page, :start_date, :end_date])
        users = Services::UserServices.top_user_by_transaction_amount(params)
        render json:users.as_json, status: users[:meta][:status]
    end

    def my_user_transaction
        users = Services::UserServices.my_user_transaction(@current_api_user)
        render json:users.as_json, status: users[:meta][:status]
    end
    
    def create_transaction
        params.require([:menu_id])
        transaction = Services::UserServices.create_transaction(@current_api_user, params)
        render json:transaction.as_json, status: transaction[:meta][:status]
    end
    
end
