class HomeController < ApplicationController
    def index
        if current_user.admin?
            redirect_to users_url
        else
            redirect_to user_notes_url(current_user)
        end
    end
end