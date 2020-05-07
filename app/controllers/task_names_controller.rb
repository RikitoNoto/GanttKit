class TaskNamesController < ApplicationController
    def index
        @name = TaskName.find_by(name: params[:name], user: current_user)
        @params = @name.task_params.order(:order)
        @tasks = Task.where(task_name: @name)
    end
end
