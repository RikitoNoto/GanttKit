class UsersController < ApplicationController
    def index
        redirect_to user_works_path(current_user)
    end
end
