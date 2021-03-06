class TasksController < ApplicationController
    before_action :set_calendar_edge_days, only: [:index, :show]
    before_action :set_user, only: [:index, :show]
    before_action :set_work, only: [:index, :new, :create, :edit, :update]
    before_action :set_task, only: [:show, :edit, :update, :destroy]
    before_action :set_data_list_for_task_form, only: [:new, :edit]

    def index
        respond_to do |format|
            format.html do
                @tasks = @user.tasks.where(work_id: params[:work_id]).includes(:progresses, :plans)
            end
            format.json do
                #planとprogressのworkを選択したときに実行
                @tasks = @work.tasks
            end
        end
    end

    def show
        @work = @task.work
        @resources = [@task.plans, @task.progresses]
    end

    def new
        @task = @work.tasks.build
    end

    def create
        @task = Task.new(task_params.merge(work_id: params[:work_id]))
        if @task.valid? and @task.set_name(_name: task_name_params[:name], user: current_user) and @task.save#まずは@taskの確認。OKならnameをsave。その後taskの保存
            @task.task_name.create_params(@task)#初期の機械学習用paramsを作成。taskのインスタンスを引数にする
            @task.users << current_user
            redirect_to user_work_tasks_path(current_user, @work)
        else
            set_data_list_for_task_form#入力補完用にユーザーの持っているtaskをすべて持ってくる
            render :new
        end
    end

    def edit
    end

    def update
        if @task.update_no_save(task_params) && @task.set_name(task_name_params[:name])
            @task.save
            redirect_to user_task_path(current_user, @task)
        else
            set_data_list_for_task_form#入力補完用にユーザーの持っているtaskをすべて持ってくる
            render :edit
        end
    end

    def destroy
        @work = @task.work
        if @task.destroy
            redirect_to work_tasks_path(@work)
        else
            redirect_to user_task_path(current_user, @task)
            #TODO: エラー起きた時のメッセージ
        end
    end

    private

    def set_task
        @task = Task.find(params[:id])
    end

    def set_data_list_for_task_form
        @tasks = current_user.tasks.distinct(:name)#入力補完用にユーザーの持っているtaskをすべて持ってくる
        #TODO: ここユニークにする
        @units = Task.units.map{|task| task.unit}
    end

    def task_params
        params.require(:task).permit(:quantity, :unit, :time, :start_date, :start_time, :end_date, :end_time, :description)
    end

    def task_name_params
        params.require(:task).permit(:name)
    end
end
