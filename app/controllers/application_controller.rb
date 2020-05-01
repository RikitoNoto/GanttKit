class ApplicationController < ActionController::Base
    before_action :authenticate_user!
    before_action :configure_permitted_parameters, if: :devise_controller?

    PREVIOUS_MONTH_TO_DISPLAY = 1
    DESTINATION_MONTH_TO_DISPLAY = 2
    

    protected

    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:name, user_option_attributes: [:start, :end]])
    end

    def calendar_base_point#カレンダーを表示するための基点をparamsの中身を確認して返す。
        if params[:base_point]#base_pointの引数を受け取っていれば、その日付。受け取っていなければ今日
            return Date.parse(params[:base_point])#文字列をDateインスタンスに変換して返す。
        else
            return Date.today
        end
    end

    def set_user#基本@userでview作成している。（多人数仕様にできるように）現状は@userにcurrent_userを入れてる
        if params[:user_id]
            @user = User.find(params[:user_id])
        else
            @user = current_user
        end
    end

    def set_work#ヘッダーでworkparamsがあったりなかったりするのでエラーが起きないように分岐を作っている。
        if params[:work_id]
            @work = Work.find(params[:work_id]).decorate
        else
            @work = nil#ここではnilだがtask#indexでユーザーの最初のワークを入れる
        end
    end

    def set_calendar_edge_days#カレンダーの開始と終了、基点日をインスタンス変数に入れる
        @base_day = calendar_base_point#カレンダーのページではこのメソッドの実行が必要
        @start_day = @base_day - PREVIOUS_MONTH_TO_DISPLAY.months
        @end_day = @base_day + DESTINATION_MONTH_TO_DISPLAY.months
    end
end
