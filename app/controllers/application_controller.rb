class ApplicationController < ActionController::Base
    before_action :authenticate_user!
    before_action :configure_permitted_parameters, if: :devise_controller?

    PREVIOUS_MONTH_TO_DISPLAY = 1
    DESTINATION_MONTH_TO_DISPLAY = 2
    

    protected

    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    end

    def calendar_base_point#カレンダーを表示するための基点をparamsの中身を確認して返す。
        if params[:base_point]#base_pointの引数を受け取っていれば、その日付。受け取っていなければ今日
            return Date.parse(params[:base_point])#文字列をDateインスタンスに変換して返す。
        else
            return Date.today
        end
    end

    def set_user
        if params[:user_id]
            @user = User.find(params[:user_id])
        else
            @user = current_user
        end
    end

    def set_work
        @work = Work.find(params[:work_id])
    end

    def set_calendar_edge_days#カレンダーの開始と終了、基点日をインスタンス変数に入れる
        @base_day = calendar_base_point#カレンダーのページではこのメソッドの実行が必要
        @start_day = @base_day - PREVIOUS_MONTH_TO_DISPLAY.months
        @end_day = @base_day + DESTINATION_MONTH_TO_DISPLAY.months
    end
end
