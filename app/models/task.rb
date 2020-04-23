class Task < ApplicationRecord
  has_many :user_tasks
  has_many :users, through: :user_tasks
  has_many :plans
  has_many :progress
  belongs_to :work

  validates :name, presence: true
  validates :start_date, presence: true
  validates :start_time, presence: true
  validates :end_date, presence: true
  validates :end_time, presence: true
  validates :quantity, presence: true

  def calendar_title_link(user: nil)
      return "/users/#{user.id}/tasks/#{self.id}"#タスクの詳細に飛ぶ
  end

  #日付とユーザーを受け取りその日の合計時間、ステータスを返す。(ステータスはcalendar_table_helperに詳細を記載)
  #workにも同名メソッドがあり(helperを使いまわしているので同名の必要あり)
  def detail_of_date(date, user)
    plans = Plan.thisday(date, user, self)
    progresses = Progress.thisday(date, user, self)
    plans_total_time = total_time(plans, when_zero: nil)
    progresses_total_time = total_time(progresses, when_zero: nil)
    total_time = progresses_total_time ? progresses_total_time : plans_total_time#進捗の時間が0ならplanの時間を返す
    status = {plan: {total_time: plans_total_time, status: get_status(date, user, Plan)},
    progress: {total_time: progresses_total_time, status: get_status(date, user, Progress)}}#planとprogressのstatusを作成
    status[:status] = status[:progress][:status] ? status[:progress][:status] : status[:plan][:status]
    return {total_time: total_time, status: status}
  end

  private


  #引数で受け取ったレコードの合計時間を出力
  #合計時間が0の場合はwhen_zeroに入っている値を返す。
  def total_time(records, when_zero: nil)
    total = 0
    records.each do |record|
      total += record.time
    end

    return when_zero if total == 0
    return total
  end

  #日付とユーザーとplanかprogressのクラスを受け取りその日のステータスを返す。(本体)
  def get_status(date, user, model)
    return nil unless total_time(model.thisday(date, user, self))#もしその日に予定も実績もなければnil
    yesterday_time = total_time(model.thisday(date - 1.days, user, self))
    tomorrow_time = total_time(model.thisday(date + 1.days, user, self))
    
    if(yesterday_time && tomorrow_time)
      return "middle"
    elsif(tomorrow_time)
      return "start"
    elsif(yesterday_time)
      return "end"
    else
      return "start-end"
    end
  end
end
