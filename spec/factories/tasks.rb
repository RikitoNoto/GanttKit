FactoryBot.define do
  factory :task do
    association :work
    name {"test task#{Faker::Number.non_zero_digit }"}
    start_date {work.start_date}
    start_time {Time.new(Date.today.year, Date.today.month, Date.today.day, 9, 0, 0)}
    end_date {work.end_date}
    end_time {Time.new(Date.today.year, Date.today.month, Date.today.day, 18, 0, 0)}
    quantity {Faker::Number.between(from: 1, to: 100000)}
    unit {"page"}
    time {Faker::Number.between(from: 1, to: 100000)}
  end
end
