module Handler
    class Res < Api::ApplicationController
        def self.call(code, message, data)
            response = {
                meta: {
                    status: code,
                    message: message
                },
                data: data
            }
    
            puts response.as_json
    
            return response
        end
    end
end