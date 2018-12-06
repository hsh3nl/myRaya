module UsersHelper
    def signed_in?
        user_id = cookies[:user_id]
        if user_id.nil?
            user_id = session[:user_id]
        end

        user = User.find_by(id: user_id)

        if user
            true
        else
            false
        end
    end

    # Returns current user if that user is signed in
    def current_user
        user_id = cookies[:user_id]
        if user_id.nil?
            user_id = session[:user_id]
        end

        user = User.find_by(id: user_id)

        if user
            user
        else
            nil
        end
    end
end
