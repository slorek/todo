FactoryGirl.define do
  factory :task do
    name 'test'
    association :user
  end
end