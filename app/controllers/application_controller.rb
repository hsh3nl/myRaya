class ApplicationController < ActionController::Base

    # Object method to check if there is someone signed in
    def signed_in?
        user_id = cookies[:user_id]
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
        user = User.find_by(id: user_id)

        if user
            user
        else
            nil
        end
    end

    #checks if user matches that of the accessed page for events controller
    def check_user_event(event)
        if current_user.nil? || event.nil? || current_user.id != event.user_id
            redirect_back(fallback_location: root_path)
        end
    end

    # checks if user matches that of the accessed page for user controller
    def check_user_profile(user)
        if current_user.nil? || user.nil? || current_user.id != user.id
            redirect_back(fallback_location: root_path)
        end
    end

end
