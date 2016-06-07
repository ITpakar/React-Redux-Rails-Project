require 'factory_girl_rails'
require 'ffaker'

FactoryGirl.define do 
  factory :section do
    name                   { FFaker::Lorem.words.join(' ').titleize }
    category_id            nil 
    activated              true
    created_by             nil
  end
end