module Api
    class ApplicationController < ActionController::API
        include ActionController::HttpAuthentication::Basic::ControllerMethods
        include ActionController::HttpAuthentication::Token::ControllerMethods
        before_action :http_basic_authenticate
        
        def http_basic_authenticate
            authenticate_or_request_with_http_basic do |username, password|
                user = User.find(username)
                hash_password = BCrypt::Password.new(user[:encrypted_password]) == password

                unless username.to_i == user[:id] && hash_password == true
                    authorized = Handler::Res.call(401, "This is not a authorized request.", nil)
                    render json: authorized.as_json, status: authorized[:meta][:status]
                else
                    @current_api_user = user
                end
            end
        end
        
    end 
end
