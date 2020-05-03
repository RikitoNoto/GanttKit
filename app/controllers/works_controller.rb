class WorksController < ApplicationController
    before_action :set_calendar_edge_days, only: [:index]
    before_action :set_user, only: [:index]
    before_action :set_work, only: [:show, :edit, :update, :destroy]

    def index
        @works = @user.works.includes(:tasks).where(display: true).order(created_at: :asc)
    end

    def show
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

    def edit
    end

    def update
        respond_to do |format|
            #通常のupdate（edit→submit）時に処理
            format.html do
                if @work.update(work_params)
                    tasks_destroy
                    redirect_to user_work_tasks_path(current_user, @work)
                else
                    render :edit
                end
            end

            #task#indexの目ボタン押下時に処理。
            #work.displayのトグル処理を行う。
            format.js do
                @work.update(display: !@work.display)
                @user = User.find(params[:user_id])
            end
        end
    end

    def destroy
        if @work.destroy
            redirect_to user_works_path(current_user)
        else
            redirect_to user_work_tasks_path(current_user, @work)
            #TODO: エラー起きた時のメッセージ
        end
    end

    private

    def work_params
        params.require(:work).permit(:name, :start_date, :end_date, :start_time, :end_time)        
    end

    def set_work
        @work = Work.find(params[:id])
    end

    def tasks_params
        params.require(:work).permit(tasks: {})           
    end

    def tasks_destroy
        tasks_params[:tasks].each do |key, value|
            if value != "0"
                Task.find(key.to_i).destroy
            end
        end
    end
end
