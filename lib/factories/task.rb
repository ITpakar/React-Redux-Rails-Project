require 'factory_girl_rails'
require 'ffaker'

FactoryGirl.define do 
  factory :task do
    title                 { FFaker::Company.bs.titleize }
    description           { FFaker::Lorem.sentence }
    status                { Task::STATUSES.sample }
    section_id            nil
    assignee_id           nil
    organization_user_id  nil
    deal_id               nil
    due_date              { DateTime.now + rand(5).months  + rand(10).days }
  end
end