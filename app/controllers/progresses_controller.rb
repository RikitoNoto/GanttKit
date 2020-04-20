class ProgressesController < ApplicationController
    before_action :set_work, only: [:new]

    def new
        @work = current_user.works.first unless @work#workの中身がnilなら適当なworkを入れる(selectorに値を入れるため)
        @progress = Progress.new
    end

    def create
        @progress = Progress.new(progress_params.merge(user_id: current_user.id))
        if @progress.save
            redirect_to user_work_tasks_path(current_user, @progress.task)
        else
            if @progress.task
                @work = @progress.task.work
            else
                @work = current_user.works.first
            end
            render :new
        end
    end

    private

    def progress_params
        params.require(:progress).permit(:quantity, :time, :start_date, :start_time, :task_id)
    end
end
