require 'factory_girl_rails'
require 'ffaker'

FactoryGirl.define do 
  factory :folder do
    name        { FFaker::Product.brand }
    created_by  nil
    activated   true
    deal_id     nil
    task_id     nil
  end
end