module CalendarTableHelper

#==========================共通===================================

    public
    private
        
    def days_during_months(start_date, end_date)#startからendまでの月数をintで返す。
        (end_date.year - start_date.year)*12 + end_date.month - start_date.month + 1 # 年の差分 * 12 + 終わりの月 - 始まりの月 + 1
    end
#=================================================================


#==========================月====================================
    public
    def create_months_row()#calendarテーブルの月の行を作成する。
        days_during_months(@start_day, @end_day).times do |i|
            month_mode = 0#フラグ変数。ループごとにリセットし、最初か最後だと変数にフラグを代入
            current = @start_day+i.months#今日の日付を代入
            if i == 0#ループの最初の場合はフラグにstartを代入
                month_mode = "start"#startのフラグを立てる
            elsif i == days_during_months(@start_day, @end_day) -1#ループの最後なら
                month_mode = "end"#endのフラグを立てる
            end

            size = month_colspan_size(current, month_mode)
            yield(size, current.month)#現在のループの月と横幅を引数としてブロック呼び出し
            #実際の呼び出し↓
            #%th.table_center.dates__month{colspan: colspan_size, style: "width: #{colspan_size*25}px"} #{month}
        end
        return nil
    end

    private

    def month_colspan_size(date, count_days)#引数の日付からその月の日数を返す。count_daysのフラグにより計算が変わる
        case count_days
        when "start"
            start_day = date.day - 1
        when "end"
            start_day = date.end_of_month.day - date.day
        else
            start_day = 0
        end
        colspan = date.end_of_month.day - start_day#Date型のオブジェクトが引数
    end
#=================================================================

#==============================日==================================

    public

    def create_days_row#カレンダーの日数繰り返しを行い、1日ごとにブロックを読み込み
        current_day = @start_day
        days = (@end_day - @start_day).to_i + 1#分数型で帰ってくるのでイント変換。日数を返す。
        days.times do |i|#開始日から終了日まで繰り返す。(最初の月の最初の日から最後の月の最後の日まで)
            yield(current_day, i+1)#ブロック読み込み
            current_day+=1.days#現在の日付に1日足す
        end
        return nil
    end


    # 〇total_time
    # その日の出力される合計時間
    # progressが優先で表示される
    # 〇point
    # 入力される場所の座標
    # [x,y]の書式で出力する
    # 〇status
    # ハッシュの配列になっており、中にはplanとprogressで4種類のステータスのうち1つずつが入っている
    # start: 開始日
    # end: 終了日
    # middle: 稼働日
    # start-end: その日に開始して終了
    # 例)[{plan: start}, {progress: end}] 

    # カレンダーのボーダーをこれで制御する
    # start: left-top-bottom
    # end: right-top-bottom
    # middle: top-bottom
    # start-end: all

    def create_days_row_with_project(project, user, y)
        #内部的にカレンダーの日付繰り返しを行う。(プロジェクトの行も日付分列があるため)
        #このメソッドはブロック変数でx座標を返してくれる
        create_days_row do |current_day, x|
            detail_of_day = project.detail_of_date(current_day, user)#{total_time: 合計時間, status: {ステータス}}
            #taskとworkのインスタンスメソッド
            #その日のユーザーの詳細を返す。
            point = [x, y]#座標の定義
            yield(detail_of_day[:total_time], point, detail_of_day[:status])
        end
    end

    def create_days_row_with_plans_progresses(details, y)
        create_days_row do |current_day, x|
            detail_of_day = detail_plans_progresses(details, current_day)#{total_time: 合計時間, status: {ステータス}}
            detail_of_day[details.model_name.to_s.downcase.to_sym] = {status: detail_of_day[:status]} if detail_of_day[:status]
            #その日のユーザーの詳細を返す。
            point = [x, y]#座標の定義
            yield(detail_of_day[:total_time], point, detail_of_day)
        end
    end
        
    private

    def detail_plans_progresses(details, date)
        details_total_time = details_date_total_time(details, date)
        if details_total_time
            #現在の日付にデータがあった場合に通る
            #ステータスの設定
            status = details_status(details, date)
        end
        return {total_time: details_total_time, status: status, parent: {status: @task.get_self_status(date)}}
        #親のtaskのインスタンスメソッドから親のステータスを取得。開始ー終了期間の背景色を変えるため
        #受け取るtaskインスタンス変数から取得。(progresses.take.taskとかだとprogressesの中身がない場合に動作しないので)
        #TODO: 他の場所で流用するならdetails.takeを一意性のあるやり方に変更必要
    end

    def details_status(details, date)
        yesterday_time = details_date_total_time(details, date - 1.days)#昨日にデータはあるかどうか確認
        tommorrow_time = details_date_total_time(details, date + 1.days)#明日にデータはあるかどうか確認
        if yesterday_time && tommorrow_time
            return "middle"
        elsif yesterday_time
            return "end"
        elsif tommorrow_time
            return "start"
        else
            return "start-end"
        end
    end

    def details_date_total_time(details, date, when_zero: nil)#受け取った日付の合計時間をdetailsから算出
        total_time = 0
        details.each do |detail|#ここで回すのはplanかprogressのassosiation
            if detail.include_date?(date)#ここで現在の日付にdetailクラスがあるかを確認
                total_time += detail.time
            end
        end
        if total_time == 0#0ならwhen_zeroの値を返す。
            return when_zero
        end

        return total_time#0以外なら合計値を返す。
    end

#=================================================================

#================================行===============================

    public
def create_project_days_row(projects)
    projects.each_with_index do |project, i|#タスクの回数分行があるのでタスクの回数繰り返す。
        x_cell = 1
        yield(project, i)
    end
    return nil
end

#=================================================================

end