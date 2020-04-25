class TasksController < ApplicationController
    before_action :set_calendar_edge_days, only: [:index]
    before_action :set_user, only: [:index]
    before_action :set_work, only: [:index, :new, :create]

    def index
        respond_to do |format|
            format.html do
                @tasks = @user.tasks.where(work_id: params[:work_id]).includes(:progresses, :plans)
            end
            format.json do
                @tasks = @work.tasks
            end
        end
    end

    def new
        @task = @work.tasks.build
        @tasks = current_user.tasks#入力補完用にユーザーの持っているtaskをすべて持ってくる
    end

    def create
        @task = Task.new(task_params.merge(work_id: params[:work_id]))
        if @task.save
            @task.users << current_user
            redirect_to user_work_tasks_path(current_user, @work)
        else
            @tasks = current_user.tasks#入力補完用にユーザーの持っているtaskをすべて持ってくる
            render :new
        end
    end

    private

    def task_params
        params.require(:task).permit(:name, :quantity, :unit, :time, :start_date, :start_time, :end_date, :end_time)
    end
end
