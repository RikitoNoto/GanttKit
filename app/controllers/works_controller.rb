class WorksController < ApplicationController
    before_action :set_calendar_edge_days, only: [:index]
    
    def index
        @user = User.find(params[:user_id])
        @works = @user.works
    end

    def new
        @work = Work.new
    end

    def create
        @work = Work.new(work_params)
        if @work.save
            @work.users << current_user
            redirect_to "/"#work_tasks_path(@work)
        else
            render :new
        end
    end

    private

    def work_params
        params.require(:work).permit(:name, :start_date, :end_date, :start_time, :end_time)        
    end
end
