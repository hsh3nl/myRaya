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

    #checks if user matches that of the accessed page for events
    def check_user_event(e)
        if current_user == nil || current_user.id != e.user_id
            redirect_to root_path
        end
    end

end
