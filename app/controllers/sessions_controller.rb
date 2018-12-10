class SessionsController < ApplicationController
    def new
    end

    def create
        email = signin_params[:email]
        password = signin_params[:password]
        remember_me = signin_params[:remember_me].to_i
        user = User.find_by(email: email).try(:authenticate, password)
        reset_session
        if user && remember_me == 1
            cookies[:user_id] = { value: user.id, expires: 7.day.from_now }
            redirect_to dashboard_path(user)
        elsif user && remember_me == 0
            cookies[:user_id] = { value: user.id, expires: 7.day.from_now }
            redirect_to dashboard_path(user)
        else
            flash[:notice] = ["Email or password incorrect"]
            redirect_to sign_in_path
        end
    end

    def destroy
        cookies.delete :user_id
        reset_session
        flash[:success] = ["You have logged out"]
        redirect_to root_path
    end

    private

    def signin_params
        params.require(:user).permit(:email, :password, :remember_me)
    end
end
