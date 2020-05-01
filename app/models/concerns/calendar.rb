module Calendar
    extend ActiveSupport::Concern
    included do
        belongs_to :user
        belongs_to :task
        alias :parent :task
    
        validates :quantity, presence: true, numericality: { greater_than: 0}
        validates :time, presence: true, numericality: { greater_than: 0}
        validates :start_date, presence: true, within_start_time: true
        validates :start_time, presence: true, within_start_time: true
        validates :end_date, presence: true, within_end_time: true
        validates :end_time, presence: true, within_end_time: true

        #指定した日のユーザーのplanかprogressを持ってくる
        # scope :thisday, -> (date,user) { where("DATE(start_date)='#{date.strftime("%Y-%m-%d")}' AND user_id='#{user.id}'").order(start: :ASC)}
        scope :thisday, -> (date,user,task) { where("DATE(start_date)='#{date.strftime("%Y-%m-%d")}' AND user_id='#{user.id}' AND task_id='#{task.id}'").order(start_date: :ASC)}
        
        #TODO: taskの期間からはみ出ていたらエラーのバリデーション
        #TODO: useroptionの期間からはみ出ていたらエラーのバリデーション
    end

    def start_time
        return nil unless start_date
        return nil unless super
        date = start_date
        return Time.new(date.year, date.month, date.day, super.hour, super.min, super.sec)
    end

    def end_date
        return nil unless end_time
        return end_time.to_date
    end

    def end_time
        return nil unless start_date and time and start_time
        return start_time + time.hours
    end

    def include_date?(date)#開始日時と終了日時から受け取った日付が範囲内かをチェックする。
        if self.start_date <= date && self.end_date >= date
            return true
        end
        return false
    end


    
end