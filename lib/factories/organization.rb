require 'factory_girl_rails'
require 'ffaker'

FactoryGirl.define do 
  factory :organization do
    # Need to specify organization_id
    name            { FFaker::Company.name }
    email_domain    { User.find(created_by).email_domain }
    phone           { FFaker::PhoneNumber.phone_number }
    address         { FFaker::Address.street_address }
    activated       'true'
    created_at      { DateTime.now }
    updated_at      { DateTime.now }
  end
end