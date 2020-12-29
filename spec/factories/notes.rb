FactoryBot.define do
  factory :note do
    message "my important note."
    association :project
    association :user
  end
end
