class Task < ApplicationRecord
  include GetterStartEndTime

  has_many :user_tasks, dependent: :destroy
  has_many :users, through: :user_tasks
  has_many :plans, dependent: :destroy
  has_many :progresses, dependent: :destroy
  belongs_to :work
  belongs_to :task_name, optional: true
  alias :parent :work

  validates :start_date, presence: true, within_start_time: true
  validates :start_time, presence: true, within_start_time: true
  validates :end_date, presence: true, within_end_time: true
  validates :end_time, presence: true, within_end_time: true, end_after_start: true
  validates :quantity, presence: true, numericality: { greater_than: 0}
  validates :time, presence: true, numericality: { greater_than: 0}

  def name
    return nil unless self.task_name
    self.task_name.name
  end


  def set_name(_name: nil, user: nil)
    self.task_name_id = TaskName.get_id(_name: _name, user: user)
    return self.name
  end

  def calendar_title_link(user: nil)
      return "/users/#{user.id}/tasks/#{self.id}"#タスクの詳細に飛ぶ
  end

  #日付とユーザーを受け取りその日の合計時間、ステータスを返す。(ステータスはcalendar_table_helperに詳細を記載)
  #workにも同名メソッドがあり(helperを使いまわしているので同名の必要あり)
  def detail_of_date(date, user)
    #TODO: N+1問題が発生している
    plans = Plan.thisday(date, user, self)
    progresses = Progress.thisday(date, user, self)
    plans_total_time = total_time(plans, when_zero: nil)
    progresses_total_time = total_time(progresses, when_zero: nil)
    total_time = progresses_total_time ? progresses_total_time : plans_total_time#進捗の時間が0ならplanの時間を返す
    status = {plan: {total_time: plans_total_time, status: get_status(date, user, Plan)},
    progress: {total_time: progresses_total_time, status: get_status(date, user, Progress)}}#planとprogressのstatusを作成
    status[:status] = status[:progress][:status] ? status[:progress][:status] : status[:plan][:status]#data-statusにプログレスがあればプログレス、なければplanのステータスをいれる。
    status[:parent] = {status: get_self_status(date)}
    return {total_time: total_time, status: status}
  end
  
  #このtask自身のステータスを返す。
  #startとendの日付で判断
  def get_self_status(date)
    if date == self.start_date && date == self.end_date
      return "start-end"
    elsif date == self.start_date
      return "start"
    elsif date == self.end_date
      return "end"
    elsif date > self.start_date && date < self.end_date
      return "middle"
    end
  end

  def self.units
    #taskで使用されているunitを取得
    #task_formで予測変換するために使用する
    Task.select(:unit).distinct
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
