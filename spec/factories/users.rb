FactoryBot.define do
  factory :user do
    name {Faker::Name.name}
    password_temp = Faker::Internet.password(min_length: 6)
    password {password_temp}
    password_confirmation {password_temp}
    email {Faker::Internet.email}
  end
end
