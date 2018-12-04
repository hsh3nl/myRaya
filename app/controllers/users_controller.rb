class UsersController < ApplicationController

    def show
        @user = User.find_by(id:params[:id])
    end

    def new
        @user = User.new
    end

    def create
        user = User.new(
            first_name: user_params[:first_name],
            last_name: user_params[:last_name],
            email: user_params[:email],
            gender: user_params[:gender],
            tel_no: user_params[:tel_no],
            image: user_params[:image],
            password: user_params[:password],
            password_confirmation: user_params[:password_confirmation]
            ) 
        if user.save
            redirect_to sign_in_path
        else
            flash[:notice] = user.errors.full_messages
            redirect_to sign_up_path
        end
    end

    def edit
        @user = User.find_by(id: params[:id])
        check_user_profile(@user)
    end

    def update
        @user = User.find_by(id: current_user.id)
        password = user_params[:password]
        if password == user_params[:password_confirmation] && @user.try(:authenticate, password)
            if @user.update(first_name: user_params[:first_name], last_name: user_params[:last_name], email: user_params[:email], tel_no: user_params[:tel_no], gender: user_params[:gender], image: user_params[:image])
                redirect_to @user
            else 
                flash[:notice] = @user.errors.full_messages
                redirect_to edit_user_path(@user)
            end
        else
            flash[:notice] = 'Incorrect password or passwords do not match. Try again'
            redirect_to edit_user_path(@user)
        end
    end

    def dashboard
        @user = User.find_by(id: params[:id])
        check_user_profile(@user)
        if @user 
            @events = @user.events
            @bookings = @user.bookings
        end
    end

    private

    def user_params
        params.require(:user).permit(:first_name, :last_name, :gender, :email, :tel_no, :password, :password_confirmation, :image, :remove_image)
    end
end
