FactoryBot.define do
  factory :task_param do
    order { 1 }
    param { 1.5 }
    task_name { nil }
  end
end
