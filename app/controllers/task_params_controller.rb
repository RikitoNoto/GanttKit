class TaskParamsController < ApplicationController
    before_action :set_task_name
    FLOOR_NUM = 8#小数点以下の切り上げ桁数

    def update
        return if params[:params].length < @task_name.task_params.length 
        @task_name.task_params.destroy_all
        params[:params].each_with_index do |param, i|
            param = BigDecimal(param.to_s).floor(FLOOR_NUM).to_f
            @task_name.task_params.create(param: param, order: i)
        end
    end


    private

    def set_task_name
        @task_name = TaskName.find(params[:task_name_id])
    end
end
