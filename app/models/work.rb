class Work < ApplicationRecord
    has_many :user_works
    has_many :users, through: :user_works
    has_many :tasks

    validates :name, presence: true
    validates :start_date, presence: true
    validates :start_time, presence: true
    validates :end_date, presence: true
    validates :end_time, presence: true


    def calendar_title_link(user: nil)
        return "/users/#{user.id}/works/#{self.id}/tasks"
    end
    

    #受け取った日付をもとにその日がtaskの範囲内なら配列にtaskを入れて返す。
    #返す際に日付に応じたstatusを入れる
    def get_the_days_task(date, user)
        tasks = []
        self.tasks.each do |task|
            next unless task.users.include?(user)#もしユーザーに関係のないタスクならスルーする。
            if task.start_date == date && task.end_date == date
                tasks << {task: task, status: "start-end"}
            elsif task.start_date == date
                tasks << {task: task, status: "start"}
            elsif task.end_date == date
                tasks << {task: task, status: "end"}
            elsif task.start_date < date && task.end_date > date
                tasks << {task: task, status: "middle"}
            end
        end
        return tasks
    end

    #日付とユーザーを受け取りその日の合計時間、ステータスを返す。(ステータスはcalendar_table_helperに詳細を記載)
    #workにも同名メソッドがあり(helperを使いまわしているので同名の必要あり)
    def detail_of_date(date, user)
        tasks = self.get_the_days_task(date, user)
        total_time = nil#workIndexの場合は合計時間は空欄とする。
        status = {status: get_status(tasks), tasks: {status: get_status(tasks)}}
        return {total_time: total_time, status: status}
    end

    private

    #ステータスを設定。work全体で見るためパターンは3つ
    #1: {:start, :middle, :end}1行の中でこれ3つ。　{:start-end}1行の中でこれ一つ。　{nil}1行に何も表示しないパターん
    def get_status(tasks)
        status = nil
        statuses = tasks.map{|task| task[:status]}
        if statuses.include?("middle")
            status = "middle"
        elsif statuses.include?("end")
            status = "end"
        elsif statuses.include?("start")
            status = "start"
        elsif statuses.include?("start-end")
            status = "start-end"
        end
        return status
    end
end
