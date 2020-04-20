class PlansController < ApplicationController
    before_action :set_work, only: [:new]

    def new
        @work = current_user.works.first unless @work#workの中身がnilなら適当なworkを入れる(selectorに値を入れるため)
        @plan = Plan.new
    end

    def create
        @plan = Plan.new(plan_params.merge(user_id: current_user.id))
        if @plan.save
            redirect_to user_work_tasks_path(current_user, @plan.task)
        else
            if @plan.task
                @work = @plan.task.work
            else
                @work = current_user.works.first
            end
            render :new
        end
    end

    private

    def plan_params
        params.require(:plan).permit(:quantity, :time, :start_date, :start_time, :task_id)
    end
end
