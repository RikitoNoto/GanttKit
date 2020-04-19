class WorksController < ApplicationController
    before_action :set_calendar_edge_days, only: [:index]
    before_action :set_user, only: [:index]

    def index
        @works = @user.works
    end

    def new
        @work = Work.new
    end

    def create
        @work = Work.new(work_params)
        if @work.save
            @work.users << current_user
            redirect_to user_works_path(current_user)
        else
            render :new
        end
    end

    private

    def work_params
        params.require(:work).permit(:name, :start_date, :end_date, :start_time, :end_time)        
    end
end
