class AuthController < ApplicationController

    def login
        # Placeholder logic for user authentication
        username = params[:username]
        password = params[:password]
    
        if username == "admin" && password == "password"
            render json: { token: "fake-jwt-token" }, status: :ok
        else
            render json: { error: "Invalid credentials" }, status: :unauthorized
        end
    end

end
