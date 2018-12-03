class SessionsController < ApplicationController
    def new
    end

    def create
        email = signin_params[:email]
        password = signin_params[:password]
        
        user = User.find_by(email: email).try(:authenticate, password)
        if user
            cookies[:user_id] = user.id
            redirect_to user_path(user)
        else
            flash[:notice] = "Email or password incorrect"
            redirect_to sign_in_path
        end
    end

    def destroy
        cookies[:user_id] = nil

        redirect_to root_path
    end

    private

    def signin_params
        params.require(:user).permit(:email, :password)
    end
end
