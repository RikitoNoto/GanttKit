module Calendar
    extend ActiveSupport::Concern
    included do
        #指定した日のユーザーのplanかprogressを持ってくる
        # scope :thisday, -> (date,user) { where("DATE(start_date)='#{date.strftime("%Y-%m-%d")}' AND user_id='#{user.id}'").order(start: :ASC)}
        scope :thisday, -> (date,user,task) { where("DATE(start_date)='#{date.strftime("%Y-%m-%d")}' AND user_id='#{user.id}' AND task_id='#{task.id}'").order(start_date: :ASC)}
    end


    
end