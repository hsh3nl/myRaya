class UsersController < ApplicationController

    def new
        @user = User.new
    end

    def create
        @user = User.new(
            first_name: user_params[:first_name],
            last_name: user_params[:last_name],
            password: user_params[:password],
            password_confirmation: user_params[:password_confirmation]
            ) 
            byebug
        if @user.save
            redirect_to sign_in_path
        else
            render :new
        end
    end

    private

    def user_params
        params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end
end
