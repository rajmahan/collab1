FactoryGirl.define do 
  factory :user do
    sequence(:name) { |n| "test#{n}" }
    sequence(:email) { |n| "test#{n}@test.com" }
    password 'test1234'
    password_confirmation 'test1234'
  end
end