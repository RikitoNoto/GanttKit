module Calendar
    extend ActiveSupport::Concern
    included do
        #指定した日のユーザーのplanかprogressを持ってくる
        # scope :thisday, -> (date,user) { where("DATE(start_date)='#{date.strftime("%Y-%m-%d")}' AND user_id='#{user.id}'").order(start: :ASC)}
        scope :thisday, -> (date,user,task) { where("DATE(start_date)='#{date.strftime("%Y-%m-%d")}' AND user_id='#{user.id}' AND task_id='#{task.id}'").order(start_date: :ASC)}
    end

    def start_time
        date = start_date
        return Time.new(date.year, date.month, date.day, super.hour, super.min, super.sec)
    end

    def end_date
        return end_time.to_date
    end

    def end_time
        date = start_date
        overflow_day = (time/24).to_i
        hour = (time%24).to_i
        min = ((time - time.to_i)/60).to_i
        sec = ((time - time.to_i)/60/60).to_i
        return Time.new(date.year, date.month, date.day + overflow_day, start_time.hour + hour, start_time.min + min, start_time.sec + sec)
    end

    def include_date?(date)#開始日時と終了日時から受け取った日付が範囲内かをチェックする。
        if self.start_date <= date && self.end_date >= date
            return true
        end
        return false
    end


    
end