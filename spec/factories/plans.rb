FactoryBot.define do
  factory :plan do
    association :user
    association :task
    start_date {task.start_date}
    start_time {Time.new(Date.today.year, Date.today.month, Date.today.day, 9, 0, 0)}
    quantity {task.quantity}
    time {task.start_time.hour - task.end_time.hour}
  end
end
