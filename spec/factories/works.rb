FactoryBot.define do
  factory :work do
    name {"test work#{Faker::Number.non_zero_digit }"}
    start_date {Date.today}
    start_time {Time.new(Date.today.year, Date.today.month, Date.today.day, 9, 0, 0)}
    end_date {Date.today + Faker::Number.non_zero_digit.days}
    end_time {Time.new(Date.today.year, Date.today.month, Date.today.day, 18, 0, 0)}
  end
end
