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

    private

#=================================================================

#================================行===============================
def create_project_days_row(projects)
    projects.each_with_index do |project, i|#タスクの回数分行があるのでタスクの回数繰り返す。
        x_cell = 1
        yield(project, i)
    end
    return nil
end

#=================================================================

end