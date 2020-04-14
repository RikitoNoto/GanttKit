class WorksController < ApplicationController
    def index
        @works = User.find(params[:user_id]).works
    end
end
